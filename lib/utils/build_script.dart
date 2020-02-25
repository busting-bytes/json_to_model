import 'package:build_runner/src/entrypoint/runner.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:json_to_model/utils/commands/clean.dart';
import 'package:json_to_model/utils/commands/generate_build_script.dart';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:io/io.dart';
import 'package:io/ansi.dart';
import 'package:build_runner/src/build_script_generate/bootstrap.dart';
import 'package:build_runner/src/logging/std_io_logging.dart';

class BuildScript {
  BuildScript(this.args);
  var commandRunner = BuildCommandRunner([]);
  var localCommands = [CleanCommand(), GenerateBuildScript()];
  List<String> args;

  ArgResults parsedArgs;
  void build() async {
    var localCommandNames = localCommands.map((c) => c.name).toSet();

    ArgResults parsedArgs;
    try {
      parsedArgs = commandRunner.parse(args);
    } on UsageException catch (e) {
      print(red.wrap(e.message));
      print('');
      print(e.usage);
      exitCode = ExitCode.usage.code;
      return;
    }

    var commandName = parsedArgs.command?.name;

    if (parsedArgs.rest.isNotEmpty) {
      print(yellow
          .wrap('Could not find a command named "${parsedArgs.rest[0]}".'));
      print('');
      print(commandRunner.usageWithoutDescription);
      exitCode = ExitCode.usage.code;
      return;
    }

    if (commandName == null || commandName == 'help') {
      commandRunner.printUsage();
      return;
    }

    final logListener = Logger.root.onRecord.listen(stdIOLogListener());
    if (localCommandNames.contains(commandName)) {
      exitCode = await commandRunner.runCommand(parsedArgs);
    } else {
      while (
          (exitCode = await generateAndRun(args)) == ExitCode.tempFail.code) {}
    }
    await logListener?.cancel();
  }
}