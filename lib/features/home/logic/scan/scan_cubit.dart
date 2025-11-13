import 'package:bloc/bloc.dart';
import 'package:finance_track/core/utils/scan/scan_service.dart';
import 'package:finance_track/features/home/logic/scan/scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(const ScanState());
  final ScanService scanService = ScanService();

  Future<void> scanReceipt({bool fromGallery = false}) async {
    emit(state.copyWith(status: ScanStatus.loading));
    try {
      final image = await scanService.pickReceiptImage(
        fromGallery: fromGallery,
      );
      if (image == null) {
        emit(
          state.copyWith(
            status: ScanStatus.error,
            message: "No image selected.",
          ),
        );
        return;
      }
      final result = await scanService.extractReceiptText(image);
      if (result == null) {
        emit(
          state.copyWith(
            status: ScanStatus.error,
            message: "Could not extract text from image.",
          ),
        );
      } else {
        emit(state.copyWith(status: ScanStatus.success, text: result));
      }
    } catch (e) {
      emit(state.copyWith(status: ScanStatus.error, message: e.toString()));
    }
  }
}
