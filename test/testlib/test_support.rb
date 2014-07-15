# Run a command line command, without intercepting stdout and stderr
def run cmd
  print "--> ",cmd
  system(cmd) 
  if $?.exitstatus != 0
    error "Command failed!"
  end
  res
end

# Error handler
def error msg
  $stderr.print "\nFATAL ERROR: ",msg,"\n"
  exit 1
end


