import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_service.dart';
import '../../core/providers/providers.dart';
import '../../l10n/app_localizations.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  final _s3EndpointController = TextEditingController();
  final _s3BucketController = TextEditingController();
  final _s3AccessKeyController = TextEditingController();
  final _s3SecretController = TextEditingController();
  final _s3PrefixController = TextEditingController();
  bool _loaded = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    _s3EndpointController.text = settings.s3Endpoint;
    _s3BucketController.text = settings.s3Bucket;
    _s3AccessKeyController.text = settings.s3AccessKey;
    _s3PrefixController.text = settings.s3Prefix;
    final secret = await ref.read(backupServiceProvider).loadS3Secret();
    _s3SecretController.text = secret ?? '';
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _s3EndpointController.dispose();
    _s3BucketController.dispose();
    _s3AccessKeyController.dispose();
    _s3SecretController.dispose();
    _s3PrefixController.dispose();
    super.dispose();
  }

  Future<void> _saveS3() async {
    final l10n = AppLocalizations.of(context)!;
    await ref.read(settingsRepositoryProvider).updateS3Config(
          endpoint: _s3EndpointController.text.trim(),
          bucket: _s3BucketController.text.trim(),
          accessKey: _s3AccessKeyController.text.trim(),
          prefix: _s3PrefixController.text.trim(),
        );
    await ref.read(backupServiceProvider).saveS3Secret(_s3SecretController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.s3ConfigSaved)),
      );
    }
  }

  Future<void> _uploadToS3() async {
    final l10n = AppLocalizations.of(context)!;
    final endpoint = _s3EndpointController.text.trim();
    final bucket = _s3BucketController.text.trim();
    final accessKey = _s3AccessKeyController.text.trim();
    final secretKey = _s3SecretController.text;
    final prefix = _s3PrefixController.text.trim();

    if (endpoint.isEmpty ||
        bucket.isEmpty ||
        accessKey.isEmpty ||
        secretKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.s3ConfigIncomplete)),
      );
      return;
    }

    setState(() => _uploading = true);
    try {
      await ref.read(settingsRepositoryProvider).updateS3Config(
            endpoint: endpoint,
            bucket: bucket,
            accessKey: accessKey,
            prefix: prefix,
          );
      await ref.read(backupServiceProvider).saveS3Secret(secretKey);
      await ref.read(backupServiceProvider).exportToS3(
            endpoint: endpoint,
            bucket: bucket,
            accessKey: accessKey,
            secretKey: secretKey,
            prefix: prefix,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.s3UploadSuccess)),
        );
      }
    } on UnsupportedError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.backupWebExportUnsupported)),
        );
      }
    } on StateError catch (e) {
      if (e.message == 's3_config_incomplete' && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.s3ConfigIncomplete)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.s3UploadFailed('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.dataBackup)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dataBackup)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.dataBackup, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              try {
                await ref.read(backupServiceProvider).exportDatabase();
              } on UnsupportedError {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.backupWebExportUnsupported)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.exportFailed('$e'))),
                  );
                }
              }
            },
            icon: const Icon(Icons.upload_file),
            label: Text(l10n.exportLocalBackup),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              try {
                await ref.read(backupServiceProvider).importDatabase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.importCompleteRestart)),
                  );
                }
              } on UnsupportedError {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.backupWebImportUnsupported)),
                  );
                }
              }
            },
            icon: const Icon(Icons.download),
            label: Text(l10n.importBackup),
          ),
          const SizedBox(height: 24),
          Text(l10n.s3Backup, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _s3EndpointController,
            decoration: InputDecoration(labelText: l10n.s3Endpoint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3BucketController,
            decoration: InputDecoration(labelText: l10n.s3Bucket),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3AccessKeyController,
            decoration: InputDecoration(labelText: l10n.s3AccessKey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3SecretController,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.s3SecretKey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3PrefixController,
            decoration: InputDecoration(labelText: l10n.s3Prefix),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saveS3, child: Text(l10n.saveS3Config)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _uploading ? null : _uploadToS3,
            child: _uploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.s3Upload),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
