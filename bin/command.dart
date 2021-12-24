import 'package:nyxx/nyxx.dart';

class Command {
  String modName;
  String cmdName;
  List<String> args;
  Message msg;

  Command(this.modName, this.cmdName, this.args, this.msg);

  TextChannel getChannel() {
    return this.msg.channel.getFromCache();
  }
}
