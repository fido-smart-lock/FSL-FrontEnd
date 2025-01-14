import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/person_card.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/role_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminAndMemberSettingMain extends StatefulWidget {
  const AdminAndMemberSettingMain(
      {super.key,
      required this.lockId,
      required this.role,
      required this.isAdmin,
      required this.lockName,
      required this.lockLocation});

  final String role;
  final String lockId;
  final bool isAdmin;
  final String lockName;
  final String lockLocation;

  @override
  State<AdminAndMemberSettingMain> createState() =>
      _AdminAndMemberSettingMainState();
}

class _AdminAndMemberSettingMainState extends State<AdminAndMemberSettingMain> {
  List<Map<String, dynamic>>? dataList = [];

  @override
  void initState() {
    super.initState();
    fetchUserLockRole();
  }

  Future<void> fetchUserLockRole() async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/lock/role/${widget.lockId}/${widget.role}';

    try {
      var data = await getJsonData(apiUri: apiUri);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(data['dataList']);
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteUserFromLock(String userId, String lockId) async {

    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/deleteUserFromLock';

    Map<String, dynamic> requestBody = {
      "userId": userId,
      "lockId": lockId,
    };

    try {
      final response = await deleteJsonDataWithRequestBody(
          apiUri: apiUri, body: requestBody);
      debugPrint('Delete successful: $response');
      await fetchUserLockRole();
    } catch (e) {
      debugPrint('Error deleting user from lock: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              size: 'xxl',
              label: widget.lockName,
              isShadow: true,
            ),
            Label(
              size: 'l',
              label: widget.lockLocation,
              color: Colors.grey.shade300,
              isShadow: true,
            ),
          ],
        ),
        actions: [
          if (widget.isAdmin)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminAndMemberAdd(
                        lockId: widget.lockId,
                        lockName: widget.lockName,
                        lockLocation: widget.lockLocation,
                        role: widget.role,
                      ),
                    ),
                  );
                },
                child: Icon(
                  CupertinoIcons.person_add,
                  size: 30,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                        color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
                  ],
                ),
              ),
            )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            size: 'xl',
            label: capitalizeFirstLetter(widget.role),
            isBold: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList?.length ?? 0, // Handle null safely
              itemBuilder: (context, index) {
                final user = dataList![index]; // Get each user from dataList
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Person(
                    isAdmin: widget.isAdmin,
                    img: user['userImage'], // Pass user image
                    name: concatenateNameAndSurname(user['userName'],
                        user['userSurname']), // Concatenate name
                    role: user['role'], // Pass role
                    button: 'remove',
                    lockName: widget.lockName,
                    lockId: widget.lockId,
                    userId: user['userId'],
                    isWaitingForApproval: user['isWaitingForApproval'],
                    onRemovePeople: (userId, lockId) => deleteUserFromLock(userId, lockId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GuestSettingMain extends StatefulWidget {
  const GuestSettingMain(
      {super.key,
      required this.lockId,
      required this.role,
      required this.isAdmin,
      required this.lockName,
      required this.lockLocation});

  final String role;
  final String lockId;
  final bool isAdmin;
  final String lockName;
  final String lockLocation;

  @override
  State<GuestSettingMain> createState() => _GuestSettingMainState();
}

class _GuestSettingMainState extends State<GuestSettingMain> {
  List<Map<String, dynamic>>? dataList = [];

  @override
  void initState() {
    super.initState();
    fetchUserLockRole();
  }

  Future<void> fetchUserLockRole() async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/lock/role/${widget.lockId}/${widget.role}';

    try {
      var data = await getJsonData(apiUri: apiUri);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(data['dataList']);
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteUserFromLock(String userId,String lockId) async {

    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/deleteUserFromLock';

    Map<String, dynamic> requestBody = {
      "userId": userId,
      "lockId": lockId,
    };
    debugPrint('Request Body: $requestBody');
    try {
      final response = await deleteJsonDataWithRequestBody(
          apiUri: apiUri, body: requestBody);
      debugPrint('Delete successful: $response');
      await fetchUserLockRole();
    } catch (e) {
      debugPrint('Error deleting user from lock: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              size: 'xxl',
              label: widget.lockName,
              isShadow: true,
            ),
            Label(
              size: 'l',
              label: widget.lockLocation,
              color: Colors.grey.shade300,
              isShadow: true,
            ),
          ],
        ),
        actions: [
          if (widget.isAdmin)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuestAdd(
                      lockId: widget.lockId,
                      lockName: widget.lockName,
                      lockLocation: widget.lockLocation,
                      role: widget.role,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  CupertinoIcons.person_add,
                  size: 30,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                        color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
                  ],
                ),
              ),
            )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            size: 'xl',
            label: capitalizeFirstLetter(widget.role),
            isBold: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList?.length ?? 0, // Handle null safely
              itemBuilder: (context, index) {
                final user = dataList![index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Person(
                    isAdmin: widget.isAdmin,
                    img: user['userImage'], // Pass user image
                    name: concatenateNameAndSurname(user['userName'] ?? '',
                        user['userSurname'] ?? ''), // Concatenate name
                    role: user['role'], // Pass role
                    button: 'remove',
                    lockName: widget.lockName,
                    lockId: widget.lockId,
                    dateTime: user['dateTime'],
                    userId: user['userId'],
                    isWaitingForApproval: user['isWaitingForApproval'],
                    onRemovePeople: (userId, lockId) => deleteUserFromLock(userId ,lockId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RequestSettingMain extends StatefulWidget {
  const RequestSettingMain({
    super.key,
    required this.lockId,
    required this.role,
    required this.lockName,
    required this.lockLocation,
  });

  final String role;
  final String lockId;
  final String lockName;
  final String lockLocation;

  @override
  State<RequestSettingMain> createState() => _RequestSettingMainState();
}

class _RequestSettingMainState extends State<RequestSettingMain> {
  List<Map<String, dynamic>>? dataList = [];

  @override
  void initState() {
    super.initState();
    fetchUserLockRequest();
  }

  Future<void> fetchUserLockRequest() async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/request/${widget.lockId}';

    try {
      var data = await getJsonData(apiUri: apiUri);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(data['dataList']);
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> acceptRequest(String notiId, [String? expireDatetime]) async {
    Map<String, dynamic> requestBody = {
      'reqId': notiId,
      'expireDatetime': expireDatetime ?? ''
    };

    debugPrint('accept all request body: $requestBody');

    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/acceptRequest';

    try {
      var response = await putJsonData(apiUri: apiUri, body: requestBody);
      debugPrint('accept request: $response');
      await fetchUserLockRequest();
    } catch (e) {
      debugPrint('Error accepting request: $e');
    }
  }

  Future<void> declineRequest(String notiId) async {
    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/delete/notification/warning/$notiId';

    try {
      final response = await deleteJsonData(apiUri: apiUri);
      debugPrint('Delete successful: $response');
      await fetchUserLockRequest();
    } catch (e) {
      debugPrint('Error deleting notification warning: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              size: 'xxl',
              label: widget.lockName,
              isShadow: true,
            ),
            Label(
              size: 'l',
              label: widget.lockLocation,
              color: Colors.grey.shade300,
              isShadow: true,
            ),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            size: 'xl',
            label: 'Request as Invited Guest',
            isBold: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList?.length ?? 0, // Handle null safely
              itemBuilder: (context, index) {
                final user = dataList![index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: PersonRequest(
                      notiId: user['notiId'] ?? '',
                      lockId: widget.lockId,
                      img: user['userImage'], // Pass user image
                      name: concatenateNameAndSurname(user['userName'],
                          user['userSurname']), // Concatenate name
                      role: user['role'], // Pass role
                      lockName: widget.lockName,
                      dateTime: user['dateTime'],
                      onAcceptRequest: (notiId, expireDatetime) =>
                          acceptRequest(notiId, expireDatetime)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
