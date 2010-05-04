import net/StreamSocket
import spry/[IRC, Commands, Prefix]

TestBot: class extends IRC {
    init: func ~TestBot (.nick, .user, .realname, .server, .port, .trigger) {
        super(nick, user, realname, server, port, trigger)
    }

    onSend: func (cmd: Command) {
        ">> " print()
        cmd toString() println()
    }

    onAll: func (cmd: Command) {
        cmd toString() println()
    }

    onNick: func (cmd: Nick) {
        "%s is now known as %s" format(cmd prefix, cmd nick()) println()
    }

//    onJoin: func (cmd: Join) {
//        if(cmd prefix nick != this nick)
//            say("Welcome to %s, %s!" format(cmd channel(), cmd prefix nick))
//    }

    onChannelMessage: func (cmd: Message) {
        handleCommand(cmd)
    }

    onPrivateMessage: func (cmd: Message) {
        handleCommand(cmd)
    }

    handleCommand: func (msg: Message) {
        if(!addressed) return

        i := commandString indexOf(' ')
        cmd := commandString[0..i]

        if(i != -1) i += 1
        rest := commandString[i..-1]

        match(cmd) {
            case "join" =>
                Join new(this, rest) send()
            case "ping" =>
                reply("pong")
            case "echo" =>
                reply(rest)
            case "trigger" =>
                trigger = rest
                reply("Done.")
            case "help" =>
                reply("ping, echo, trigger, help")
            case "die" =>
                if(rest == "   ") exit(0)
        }
    }
}

main: func {
    bot := TestBot new("spry", "spry", "a spry little IRC bot", "irc.ninthbit.net", 6667, "!")
    bot run()
}
