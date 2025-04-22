// ignore_for_file: avoid_print
import 'dart:io';

const pubspecPath = 'pubspec.yaml';
const changelogPath = 'CHANGELOG.md';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    _showHelp();
    exit(1);
  }

  final arg = args.first;

  switch (arg) {
    case '--version':
      final version = await _getVersion();
      if (version == null) {
        stderr.writeln('Version not found in $pubspecPath');
        exit(1);
      }
      print(version);
      break;

    case '--description':
      final version = await _getVersion();
      if (version == null) {
        stderr.writeln('Version not found in $pubspecPath');
        exit(1);
      }
      final description = await _getDescription(version);
      if (description == null) {
        stderr.writeln(
            'Description not found in $changelogPath for version $version');
        exit(1);
      }
      print(description);
      break;

    default:
      _showHelp();
      exit(1);
  }
}

Future<String?> _getVersion() async {
  final pubspec = await File(pubspecPath).readAsLines();
  for (final line in pubspec) {
    if (line.trim().startsWith('version:')) {
      final parts = line.split('version:');
      if (parts.length > 1) {
        final version = parts[1].trim().split('+').first;
        return version;
      }
    }
  }
  return null;
}

Future<String?> _getDescription(String version) async {
  final changelog = await File(changelogPath).readAsLines();

  final buffer = StringBuffer();
  bool inSection = false;

  for (final line in changelog) {
    if (line.startsWith('##') && line.contains(version)) {
      inSection = true;
      continue;
    }

    if (inSection && line.startsWith('##')) {
      break;
    }

    if (inSection) {
      buffer.writeln(line);
    }
  }

  final result = buffer.toString().trim();
  return result.isEmpty ? null : result;
}

void _showHelp() {
  print('''
Usage: dart musily_metadata.dart [--version | --description]
  --version       Display the current version from pubspec.yaml
  --description   Display the description for the current version from CHANGELOG.md
''');
}
