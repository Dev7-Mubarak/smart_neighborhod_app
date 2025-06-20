import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/models/project_catgory.dart';
import '../../components/constants/api_link.dart';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../core/errors/exception.dart';
import '../../models/family_Type.dart';
import 'project_category_state.dart';

class ProjectCategoryCubit extends Cubit<ProjectCategoryState> {
  ProjectCategoryCubit({required this.api}) : super(ProjectCategoryInitial());
  static ProjectCategoryCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Future<void> getProjectCategories() async {
    emit(ProjectCategoryLoading());
    try {
      final response = await api.get(
        ApiLink.getAllProjectCatgories,
      );

      if (response["data"] == null) {
        throw Serverexception(
       errModel:ErrorModel(statusCode: '400', errorMessage: "No data received",isSuccess: response["isSuccess"]??false));
      }

      List<dynamic> projectCatgories = response["data"];

      emit(ProjectCategoryLoaded(
          projectCategories:
              projectCatgories.map((e) => ProjectCategory.fromJson(e)).toList()));
    } on Serverexception catch (e) {
      emit(ProjectCategoryFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ProjectCategoryFailure(errorMessage: e.toString()));
    }
  }
}
