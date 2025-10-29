import 'dart:io';

import 'package:finance_track/features/settings/data/setting_remote_data.dart';
import 'package:finance_track/features/settings/logic/image/image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCubit extends Cubit<ImageState> {
  SettingRemoteData remoteData = SettingRemoteData();
  ImageCubit() : super(ImageState(status: ImageStatus.initial));

  void uploadImage(File imageFile) async {
    emit(state.copyWith(status: ImageStatus.loading));
    try {
      await remoteData.uploadImage(img: imageFile);

      emit(
        state.copyWith(
          status: ImageStatus.success,
          message: "Image uploaded successfully",
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ImageStatus.error, message: e.toString()));
    }
  }

  void getImage() async {
    emit(state.copyWith(status: ImageStatus.loading));
    try {
      final image = await remoteData.getImage();

      emit(state.copyWith(status: ImageStatus.success, imageUrl: image));
    } catch (e) {
      emit(state.copyWith(status: ImageStatus.error, message: e.toString()));
    }
  }
}
