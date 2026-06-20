import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/backup/backup_service.dart';
import '../../core/providers/providers.dart';
import '../../domain/models/enums.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _percentController = TextEditingController();
  final _amountController = TextEditingController();
  final _s3EndpointController = TextEditingController();
  final _s3BucketController = TextEditingController();
  final _s3AccessKeyController = TextEditingController();
  final _s3SecretController = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    _percentController.text = settings.largeChangeThresholdPercent.toString();
    _amountController.text = settings.largeChangeThresholdAmount.toString();
    _s3EndpointController.text = settings.s3Endpoint;
    _s3BucketController.text = settings.s3Bucket;
    _s3AccessKeyController.text = settings.s3AccessKey;
    final secret = await ref.read(backupServiceProvider).loadS3Secret();
    _s3SecretController.text = secret ?? '';
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _percentController.dispose();
    _amountController.dispose();
    _s3EndpointController.dispose();
    _s3BucketController.dispose();
    _s3AccessKeyController.dispose();
    _s3SecretController.dispose();
    super.dispose();
  }

  Future<void> _saveThresholds() async {
    await ref.read(settingsRepositoryProvider).updateThresholds(
          percent: double.parse(_percentController.text),
          amount: double.parse(_amountController.text),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('阈值已保存')),
      );
    }
  }

  Future<void> _saveS3() async {
    await ref.read(settingsRepositoryProvider).updateS3Config(
          endpoint: _s3EndpointController.text.trim(),
          bucket: _s3BucketController.text.trim(),
          accessKey: _s3AccessKeyController.text.trim(),
        );
    await ref.read(backupServiceProvider).saveS3Secret(_s3SecretController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('S3 配置已保存')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('展示设置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          settingsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (settings) {
              final display = Currency.fromString(settings.displayCurrency);
              return SegmentedButton<Currency>(
                segments: Currency.values
                    .map((c) => ButtonSegment(value: c, label: Text(c.code)))
                    .toList(),
                selected: {display},
                onSelectionChanged: (set) async {
                  await ref
                      .read(settingsRepositoryProvider)
                      .updateDisplayCurrency(set.first);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Text('大额变动阈值', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _percentController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: '变动百分比 (%)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: '变动金额（展示币种）'),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saveThresholds, child: const Text('保存阈值')),
          const SizedBox(height: 24),
          Text('数据备份', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              try {
                await ref.read(backupServiceProvider).exportDatabase();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('导出失败: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('导出本地备份'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(backupServiceProvider).importDatabase();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('导入完成，请重启应用')),
                );
              }
            },
            icon: const Icon(Icons.download),
            label: const Text('导入备份'),
          ),
          const SizedBox(height: 24),
          Text('S3 备份（预留）', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _s3EndpointController,
            decoration: const InputDecoration(labelText: 'Endpoint'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3BucketController,
            decoration: const InputDecoration(labelText: 'Bucket'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3AccessKeyController,
            decoration: const InputDecoration(labelText: 'Access Key'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _s3SecretController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Secret Key'),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saveS3, child: const Text('保存 S3 配置')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: null,
            child: const Text('上传到 S3（即将支持）'),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
