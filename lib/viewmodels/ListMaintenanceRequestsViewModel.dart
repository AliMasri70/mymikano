import 'package:mymikano_app/models/MaintenanceRequestModel.dart';
import 'package:mymikano_app/services/FetchMaintenanceRequestsService.dart';

class ListMaintenanceRequestsViewModel {
  List<MaintenanceRequestsViewModel>? maintenanceRequests;
  late MaintenanceRequestsViewModel maintenanceRequest;

  Future<void> fetchMaintenanceRequests() async {
    final apiresult =
        await MaintenanceRequestService().fetchMaintenanceRequest();
    this.maintenanceRequests =
        apiresult.map((e) => MaintenanceRequestsViewModel(e)).toList();
  }

  Future<MaintenanceRequestsViewModel> fetchMaintenanceRequestsByID(
      int id) async {
    final apiresult =
        await MaintenanceRequestService().fetchMaintenanceRequestByID(id);
    this.maintenanceRequest = MaintenanceRequestsViewModel(apiresult);
    return this.maintenanceRequest;
  }
}

class MaintenanceRequestsViewModel {
  final MaintenanceRequestModel? mMaintenacerequest;
  MaintenanceRequestsViewModel(this.mMaintenacerequest);
}
