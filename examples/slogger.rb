# -*- encoding: utf-8 -*-

=begin

Example STOMP call back logger class.

Optional callback methods:

    on_connecting: connection starting
    on_connected: successful connect
    on_connectfail: unsuccessful connect (will usually be retried)
    on_disconnect: successful disconnect

    on_miscerr: on miscellaneous xmit/recv errors

    on_publish: publish called
    on_subscribe: subscribe called
    on_receive: receive called and successful

    on_ssl_connecting: SSL connection starting
    on_ssl_connected: successful SSL connect
    on_ssl_connectfail: unsuccessful SSL connect (will usually be retried)

    on_hbread_fail: unsuccessful Heartbeat read
    on_hbwrite_fail: unsuccessful Heartbeat write

All methods are optional, at the user's requirements.

If a method is not provided, it is not called (of course.)

IMPORTANT NOTE:  in general, call back logging methods *SHOULD* not raise exceptions, 
otherwise the underlying STOMP connection may fail in mysterious ways.

There are two useful exceptions to this rule for:

    on_connectfail
    on_ssl_connectfail

These two methods can raise a Stomp::Errors::LoggerConnectionError.  If this
exception is raised, it is passed up the chain to the caller.

Callback parameters: are a copy of the @parameters instance variable for
the Stomp::Connection.

=end

require 'logger'	# use the standard Ruby logger .....

class Slogger
  #
  def initialize(init_parms = nil)
    @log = Logger::new(STDOUT)		# User preference
    @log.level = Logger::DEBUG		# User preference
    @log.info("Logger initialization complete.")
  end

  # Log connecting events
  def on_connecting(parms)
    begin
      @log.debug "Connecting: #{info(parms)}"
    rescue
      @log.debug "Connecting oops"
    end
  end

  # Log connected events
  def on_connected(parms)
    begin
      @log.debug "Connected: #{info(parms)}"
    rescue
      @log.debug "Connected oops"
    end
  end

  # Log connectfail events
  def on_connectfail(parms)
    begin
      @log.debug "Connect Fail #{info(parms)}"
    rescue
      @log.debug "Connect Fail oops"
    end
=begin
    # An example LoggerConnectionError raise
    @log.debug "Connect Fail, will raise"
    raise Stomp::Error::LoggerConnectionError.new("quit from connect")
=end
  end

  # Log disconnect events
  def on_disconnect(parms)
    begin
      @log.debug "Disconnected #{info(parms)}"
    rescue
      @log.debug "Disconnected oops"
    end
  end

  # Log miscellaneous errors
  def on_miscerr(parms, errstr)
    begin
      @log.debug "Miscellaneous Error #{info(parms)}"
      @log.debug "Miscellaneous Error String #{errstr}"
    rescue
      @log.debug "Miscellaneous Error oops"
    end
  end

  # Subscribe
  def on_subscribe(parms, headers)
    begin
      @log.debug "Subscribe Parms #{info(parms)}"
      @log.debug "Subscribe Headers #{headers}"
    rescue
      @log.debug "Subscribe oops"
    end
  end

  # Publish
  def on_publish(parms, message, headers)
    begin
      @log.debug "Publish Parms #{info(parms)}"
      @log.debug "Publish Message #{message}"
      @log.debug "Publish Headers #{headers}"
    rescue
      @log.debug "Publish oops"
    end
  end

  # Receive
  def on_receive(parms, result)
    begin
      @log.debug "Receive Parms #{info(parms)}"
      @log.debug "Receive Result #{result}"
    rescue
      @log.debug "Receive oops"
    end
  end

  # Stomp 1.1+ - heart beat read (receive) failed
  def on_hbread_fail(parms, ticker_data)
    begin
      @log.debug "Hbreadf Parms #{info(parms)}"
      @log.debug "Hbreadf Result #{ticker_data}"
    rescue
      @log.debug "Hbreadf oops"
    end
  end

  # Stomp 1.1+ - heart beat send (transmit) failed
  def on_hbwrite_fail(parms, ticker_data)
    begin
      @log.debug "Hbwritef Parms #{info(parms)}"
      @log.debug "Hbwritef Result #{ticker_data}"
    rescue
      @log.debug "Hbwritef oops"
    end
  end

  def on_ssl_connecting(parms)
    begin
      @log.debug "SSL Connecting Parms #{info(parms)}"
    rescue
      @log.debug "SSL Connecting oops"
    end
  end

  def on_ssl_connected(parms)
    begin
      @log.debug "SSL Connected Parms #{info(parms)}"
    rescue
      @log.debug "SSL Connected oops"
    end
  end

  def on_ssl_connectfail(parms)
    begin
      @log.debug "SSL Connect Fail Parms #{info(parms)}"
      @log.debug "SSL Connect Fail Exception #{parms[:ssl_exception]}, #{parms[:ssl_exception].message}"
    rescue
      @log.debug "SSL Connect Fail oops"
    end
=begin
    # An example LoggerConnectionError raise
    @log.debug "SSL Connect Fail, will raise"
    raise Stomp::Error::LoggerConnectionError.new("quit from SSL connect")
=end
  end

  private

  def info(parms)
    #
    # Available in the Hash:
    # parms[:cur_host]
    # parms[:cur_port]
    # parms[:cur_login]
    # parms[:cur_passcode]
    # parms[:cur_ssl]
    # parms[:cur_recondelay]
    # parms[:cur_parseto]
    # parms[:cur_conattempts]
    #
    # For the on_ssl_connectfail callback these are also available:
    # parms[:ssl_exception]
    #
    "Host: #{parms[:cur_host]}, Port: #{parms[:cur_port]}, Login: Port: #{parms[:cur_login]}, Passcode: #{parms[:cur_passcode]}, ssl: #{parms[:cur_ssl]}"
  end
end # of class

