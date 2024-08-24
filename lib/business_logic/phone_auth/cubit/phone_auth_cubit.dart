import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());

  Future<void> submitePhoneNumber(String phoneNumber) async {
    emit(Loading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 30),
    );
  }

  Future<void> verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
    // await signIn(credential);
  }

  Future<void> verificationFailed(FirebaseAuthException error) async {
    print('verificationFailed');
    emit(ErrorOccurred(errorMsg: error.toString()));
  }

  Future<void> codeSent(String verificationId, int? resendToken) async {
    this.verificationId = verificationId;

    emit(PhoneNumberSubmited());
  }

  Future<void> codeAutoRetrievalTimeout(String verificationId) async {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otpCode);

    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified());
    } catch (error) {
      emit(ErrorOccurred(errorMsg: error.toString()));
    }
  }

  Future<void> logOut() async {
    // emit(Loading());
    await FirebaseAuth.instance.signOut();
  }

  User? getLoggedUser() {
    User? fireBaseUser = FirebaseAuth.instance.currentUser;
    return fireBaseUser;
  }
}
