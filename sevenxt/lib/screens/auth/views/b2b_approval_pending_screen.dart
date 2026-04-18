import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sevenxt/route/route_constants.dart';
import 'package:sevenxt/screens/helpers/user_helper.dart';
import '../../../route/api_service.dart';

class B2BApprovalPendingScreen extends StatefulWidget {
  const B2BApprovalPendingScreen({super.key});

  @override
  State<B2BApprovalPendingScreen> createState() => _B2BApprovalPendingScreenState();
}

class _B2BApprovalPendingScreenState extends State<B2BApprovalPendingScreen> {
  bool _isLoading = false;

  Future<void> _updateDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (result.files.length > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at most 2 files (GST and PAN)')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        List<http.MultipartFile> multipartFiles = [];
        for (var i = 0; i < result.files.length; i++) {
          final file = result.files[i];
          final fieldName = i == 0 ? 'gst_certificate' : 'business_license';
          if (file.path != null) {
            multipartFiles.add(await http.MultipartFile.fromPath(fieldName, file.path!));
          }
        }

        await ApiService.putMultipart(
          '/users/me/b2b/documents',
          files: multipartFiles,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Documents updated successfully! Our team will review them.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update documents: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Approval')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your B2B account is pending approval.\nWe\'ll notify you once reviewed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _updateDocuments,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Update Documents (If Mistake)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final authBox = Hive.box('auth');
                        await authBox.delete('token');
                        await authBox.delete('is_guest');
                        await authBox.delete('user_email');
                        await authBox.delete('user_phone');
                        await authBox.delete('user_name');
                        await authBox.delete('is_approved');
                        UserHelper.clearUserType();
                        ApiService.token = null;
                        Navigator.pushReplacementNamed(context, logInScreenRoute);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}