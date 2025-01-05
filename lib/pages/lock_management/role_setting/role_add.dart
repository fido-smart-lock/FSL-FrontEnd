import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/card/person_card.dart';
import 'package:fido_smart_lock/component/input/date_picker.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/input/time_picker.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminAndMemberAdd extends StatefulWidget {
  const AdminAndMemberAdd(
      {super.key,
      required this.lockName,
      required this.lockLocation,
      required this.role,
      required this.lockId});

  final String lockName;
  final String lockLocation;
  final String role;
  final String lockId;

  @override
  State<AdminAndMemberAdd> createState() => _AdminAndMemberAddState();
}

class _AdminAndMemberAddState extends State<AdminAndMemberAdd> {
  String? userCode = '';
  List<Map<String, dynamic>>? dataList;

  @override
  void initState() {
    super.initState();
    fetchUserCode();
  }

  Future<void> fetchUserCode() async {
    const storage = FlutterSecureStorage();
    String? userCodeFromStorage = await storage.read(key: 'userCode');

    setState(() {
      userCode = userCodeFromStorage;
    });
  }

  Future<void> fetchUser(String invitedUserCode) async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/user/$invitedUserCode';

    try {
      var data = await getJsonData(apiUri: apiUri);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(data['dataList']);
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    debugPrint('userCode: $userCode');

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
            label: 'Add New ${capitalizeFirstLetter(widget.role)}',
            isBold: true,
          ),
          UserCodeInput(
            onFindPressed: (userInput) {
              fetchUser(userInput);
            },
          ),
          SizedBox(
            height: responsive.heightScale(5),
          ),
          Label(
            size: 'xs',
            label: 'Your user code is $userCode',
            color: Colors.grey.shade500,
          ),
          if (widget.role == 'member')
            Label(
              size: 'xxs',
              label:
                  'Members have no expiration date access. If you want to add users with limited access, consider using ‘invite new guest’.',
              color: Colors.grey.shade500,
            ),
          Expanded(
            child: ListView.builder(
              itemCount: dataList?.length ?? 0, // Handle null safely
              itemBuilder: (context, index) {
                final user = dataList![index]; // Get each user from dataList
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Person(
                    desUserId: user['userId'],
                    invitedRole: widget.role,
                    lockId: widget.lockId,
                    img: user['userImage'], // Pass user image
                    name: concatenateNameAndSurname(
                        user['userName'], user['userSurname']),
                    button: 'invite',
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

class GuestAdd extends StatefulWidget {
  const GuestAdd(
      {super.key,
      required this.lockName,
      required this.lockLocation,
      required this.role,
      required this.lockId});

  final String lockName;
  final String lockLocation;
  final String role;
  final String lockId;

  @override
  State<GuestAdd> createState() => _GuestAddState();
}

class _GuestAddState extends State<GuestAdd> {
  List<Map<String, dynamic>>? dataList;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> fetchUser(String invitedUserCode) async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/user/$invitedUserCode';

    try {
      var data = await getJsonData(apiUri: apiUri);
      setState(() {
        dataList = List<Map<String, dynamic>>.from(data['dataList']);
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        dataList = []; // Set to empty to prevent null errors
      });
    }
  }

  String? getIsoDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      return dateTime.toIso8601String();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

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
              label: 'Add New ${capitalizeFirstLetter(widget.role)}',
              isBold: true,
            ),
            UserCodeInput(
              onFindPressed: (userInput) {
                fetchUser(userInput);
              },
            ),
            SizedBox(
              height: responsive.heightScale(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(size: 's', label: 'Expiration Date'),
                    SizedBox(
                      height: responsive.widthScale(3),
                    ),
                    DatePickerWidget(
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          debugPrint('Date: $_selectedDate');
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: responsive.widthScale(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(size: 's', label: 'Time'),
                    SizedBox(
                      height: responsive.widthScale(3),
                    ),
                    TimePickerWidget(
                      onTimeSelected: (time) {
                        setState(() {
                          _selectedTime = time;
                          debugPrint('Time: $_selectedTime');
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: responsive.heightScale(10),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dataList?.length ?? 0, // Handle null safely
                itemBuilder: (context, index) {
                  final user = dataList![index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Person(
                      desUserId: user['userId'],
                      invitedRole: widget.role,
                      lockId: widget.lockId,
                      img: user['userImage'], // Pass user image
                      name: concatenateNameAndSurname(
                          user['userName'], user['userSurname']),
                      button: 'invite',
                      expirationDateTime: getIsoDateTime(),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
