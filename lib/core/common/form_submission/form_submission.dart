import '../network/data_failure.dart';

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class SubmittingForm<Input> extends FormSubmissionStatus {
  Input? data;
  SubmittingForm({this.data});
}

class SubmissionSuccess<Input> extends FormSubmissionStatus {
  Input data;
  SubmissionSuccess(this.data);
}

class SubmissionFailure extends FormSubmissionStatus {
  DataFailure exception;
  SubmissionFailure(this.exception);
}
