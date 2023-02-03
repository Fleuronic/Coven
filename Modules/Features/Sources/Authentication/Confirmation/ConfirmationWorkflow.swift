// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowContainers
import Ergo

import enum Assets.Strings
import struct Coven.Credentials
import struct Textbelt.User
import struct Textbelt.PhoneNumber
import struct Textbelt.OTP
import protocol TextbeltService.OTPSpec

extension Authentication.Confirmation {
	struct Workflow<OTPService: OTPSpec> where
		OTPService.DeliveryResult == OTP.Delivery.Result,
		OTPService.VerificationResult == OTP.Verification.Result {
		private let credentials: Credentials
		private let otpService: OTPService

		init(
			credentials: Credentials,
			otpService: OTPService
		) {
			self.credentials = credentials
			self.otpService = otpService
		}
	}
}

// MARK: -
extension Authentication.Confirmation.Workflow: Workflow {
	typealias Rendering = BackStack.Item

	enum Output {
		case confirmation
		case cancellation(switchPhoneNumber: Bool)
	}

	struct State {
		var otpInputState: OTP.InputState = .pending(input: .empty)
		var otpDeliveryState: OTP.Delivery.State = .requesting
		var otpVerificationState: OTP.Verification.State = .idle
		var rejectedOTPs: Set<OTP> = []
	}

	func makeInitialState() -> State {
		.init()
	}

	func render(state: State, context: RenderContext<Self>) -> Rendering {
		context.run(
			state
				.worker(deliveringOTPToUserWith: userID, at: phoneNumber, using: otpService)?
				.mapOutput(Action.finishOTPDelivery),
			state
				.worker(verifying: state.otpInputState.input, forUserWith: userID, using: otpService)?
				.mapOutput(Action.finishOTPVerification)
		)

		return item(
			state: state,
			sink: context.makeSink(of: Action.self)
		)
	}
}

// MARK: -
extension Authentication.Confirmation.Workflow {
	enum Action {
		case finishOTPDelivery(OTP.Delivery.Result)
		case resendOTP
		case updateOTP(OTP)
		case finishOTPVerification(OTP.Verification.Result)
		case retryOTPVerification
		case cancel(switchPhoneNumber: Bool = false)
	}
}

// MARK: -
private extension Authentication.Confirmation.Workflow {
	var userID: User.ID {
		.init(text: credentials.user.username.rawValue)
	}

	var phoneNumber: PhoneNumber {
		.init(text: credentials.account.phoneNumber.rawValue)
	}

	func screen(state: State, sink: Sink<Action>) -> Alert.Screen<Authentication.Confirmation.Screen> {
		.init(
			baseScreen: .init(
				canInputOTP: state.canInputOTP,
				otpInputState: state.otpInputState,
				otpDigitsEdited: { sink.send(.updateOTP(.init(text: $0))) }
			), alert: state.deliveryAlert {
				sink.send(.resendOTP)
			} switchNumberHandler: {
				sink.send(.cancel(switchPhoneNumber: true))
			} ?? state.verificationAlert {
				sink.send(.retryOTPVerification)
			} tryAgainLaterHandler: {
				sink.send(.cancel())
			}
		)
	}

	func item(state: State, sink: Sink<Action>) -> BackStack.Item {
		.init(
			screen: screen(
				state: state,
				sink: sink
			).asAnyScreen(),
			barContent: .init(
				title: "Confirm Credentials",
				leftItem: .init(
					content: .back(title: "Credentials"),
					handler: { sink.send(.cancel()) }
				),
				rightItem: state.isRequesting ? .init(content: .spinner) : nil
			)
		)
	}
}

// MARK: -
extension Authentication.Confirmation.Workflow.Action: WorkflowAction {
	typealias WorkflowType = Authentication.Confirmation.Workflow<OTPService>

	func apply(toState state: inout WorkflowType.State) -> WorkflowType.Output? {
		switch self {
		case let .finishOTPDelivery(.success(delivery)):
			state.otpDeliveryState = .retrieved(delivery)
		case let .finishOTPDelivery(.failure(error)):
			state.otpDeliveryState = .failed(error)
		case .resendOTP:
			state.otpDeliveryState = .requesting
		case let .updateOTP(otp):
			state.handleUpdatedOTP(otp)
		case let .finishOTPVerification(.success(verification)):
			state.otpVerificationState = .retrieved(verification)
			if verification.hasVerifiedOTP {
				state.handleVerifiedOTP()
				return .confirmation
			} else {
				state.handleRejectedOTP()
			}
		case let .finishOTPVerification(.failure(error)):
			state.otpVerificationState = .failed(error)
		case .retryOTPVerification:
			state.otpVerificationState = .requesting
		case let .cancel(switchPhoneNumber):
			return .cancellation(switchPhoneNumber: switchPhoneNumber)
		}
		return nil
	}
}

// MARK: -
private extension Authentication.Confirmation.Workflow.State {
	var isRequesting: Bool {
		otpDeliveryState.isRequesting || otpVerificationState.isRequesting
	}

	var canInputOTP: Bool {
		switch otpDeliveryState {
		case .retrieved:
			return true
		default:
			return false
		}
	}

	func worker(deliveringOTPToUserWith id: User.ID, at phoneNumber: PhoneNumber, using otpService: OTPService) -> RequestWorker<OTP.Delivery.Result>? {
		otpDeliveryState.mapRequesting(
			.init { await otpService.deliverOTP(toUserWith: id, at: phoneNumber) }
		)
	}

	func worker(verifying otp: OTP, forUserWith id: User.ID, using otpService: OTPService) -> RequestWorker<OTP.Verification.Result>? {
		otpVerificationState.mapRequesting(
			.init { await otpService.verify(otp, forUserWith: id) }
		)
	}

	func deliveryAlert(
		tryAgainHandler: @escaping () -> Void,
		switchNumberHandler: @escaping () -> Void
	) -> Alert? {
		otpDeliveryState.mapError { error in
			.init(
				title: "Error Sending Confirmation Code",
				message: "We were unable to send a confirmation code to the phone number you gave. Try using a different phone number. We can also try sending the code to this number again.",
				actions: [
					.init(
						title: "Try Again",
						handler: tryAgainHandler
					),
					.init(
						title: "Switch Number",
						handler: switchNumberHandler
					),
				]
			)
		}
	}

	func verificationAlert(
		tryAgainNowHandler: @escaping () -> Void,
		tryAgainLaterHandler: @escaping () -> Void
	) -> Alert? {
		otpVerificationState.mapError { error in
			.init(
				 title: "Error Verifying Confirmation Code",
				 message: "We were unable to verify your confirmation code. Try again later. We can also try verifying this code again.",
				 actions: [
					.init(
						title: "Try Again Now",
						handler: tryAgainNowHandler
					),
					.init(
						 title: "Try Again Later",
						 handler: tryAgainLaterHandler
					)
				]
			)
		}
	}

	mutating func handleUpdatedOTP(_ otp: OTP) {
		let hasRejectedOTP = rejectedOTPs.contains(otp)
		let shouldSubmitOTP = otp.isComplete && !rejectedOTPs.contains(otp)

		if hasRejectedOTP {
			otpInputState.verificationState = .rejected
		} else {
			otpInputState.verificationState = otp.isComplete ? .verifying : .pending(complete: false)
		}

		otpInputState.input = otp
		otpVerificationState = shouldSubmitOTP ? .requesting : .idle
	}

	mutating func handleVerifiedOTP() {
		otpInputState.verificationState = .verified
	}

	mutating func handleRejectedOTP() {
		otpInputState.verificationState = .rejected
		rejectedOTPs.insert(otpInputState.input)
	}
}

// MARK: -
extension OTP {
	struct InputState {
		var input: OTP
		var verificationState: VerificationState
	}
}

// MARK: -
extension OTP.InputState {
	enum VerificationState {
		case pending(complete: Bool)
		case verifying
		case verified
		case rejected
	}

	static func pending(input: OTP) -> Self {
		.init(
			input: input,
			verificationState: .pending(complete: input.isComplete)
		)
	}
}

// MARK: -
extension OTP.InputState.VerificationState: Equatable {}
