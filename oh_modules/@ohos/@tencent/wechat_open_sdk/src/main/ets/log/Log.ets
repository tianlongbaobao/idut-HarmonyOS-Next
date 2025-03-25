import util from '@ohos.util';

export enum LogLevel {
  verbose,  // More detailed information.
  debug,    // Detailed information on the flow through the system.
  info,     // Interesting runtime events (startup/shutdown), should be conservative and keep to a minimum.
  warn,     // Other runtime situations that are undesirable or unexpected, but not necessarily "wrong".
  error,    // Other runtime errors or unexpected conditions.
  fatal,    // Severe errors that cause premature termination.
}

export interface LogInterface {
  print(level: LogLevel, tag: string, message: string): void
}

class LogDefaultImpl implements LogInterface {
  print(level: LogLevel, tag: string, message: string): void {
    let logFunc: (message: string) => void =
      (() => {
        switch (level) {
          case LogLevel.verbose: return console.log
          case LogLevel.debug:   return console.debug
          case LogLevel.info:    return console.info
          case LogLevel.warn:    return console.warn
          case LogLevel.error:   return console.error
          case LogLevel.fatal:   return console.assert
        }
      })()
    logFunc('[' + tag + '] ' + message)
  }
}

export class Log {
  private static log: LogInterface = new LogDefaultImpl

  public static setLogImpl(impl: LogInterface) {
    Log.log = impl
  }

  public static d(tag: string, format: string, ...args: Object[]) { Log.printf(LogLevel.debug, tag, format, ...args); }
  public static i(tag: string, format: string, ...args: Object[]) { Log.printf(LogLevel.info, tag, format, ...args); }
  public static w(tag: string, format: string, ...args: Object[]) { Log.printf(LogLevel.warn, tag, format, ...args); }
  public static e(tag: string, format: string, ...args: Object[]) { Log.printf(LogLevel.error, tag, format, ...args); }

  private static printf(level: LogLevel, tag: string, format: string, ...args: Object[]) {
    Log.log.print(level, tag, util.format(format, ...args))
  }
}