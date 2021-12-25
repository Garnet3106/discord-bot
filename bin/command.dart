import 'package:nyxx/nyxx.dart';

import 'TestBOT.dart';

class Command {
  String modName;
  String cmdName;
  List<String> args;
  Message msg;

  Command(this.modName, this.cmdName, this.args, this.msg);

  TextChannel getChannel() {
    return this.msg.channel.getFromCache() ??
        terminate('There is no channel in the cache.');
  }

  String getArgumentAt(int index) {
    if (index >= this.args.length) {
      throw 'Invalid Argument Length';
    } else {
      return this.args[index];
    }
  }
}
