class ParallelRun
  def execute_parallel_run
    pid_list=[]
    parallel_instances=ARGV[0].to_i
    puts parallel_instances

    feature_list= get_tests_to_run
    puts feature_list
    #cleanup
    feature_list.each do |file|
      pid = spawn("bundle exec rspec #{file} --format documentation --format html --out spec-results/index.html")
      Process.detach(pid)
      pid_list << pid
      sleep 1
      while pid_list.size >= parallel_instances
        wait_for_process_to_finish(pid_list)
      end
    end

    while pid_list.size != 0
      wait_for_process_to_finish(pid_list)
    end

    #create_failed_test_list
    puts "Finished all the process"
  end

  def get_tests_to_run
    File.exist?("failed_test") ? File.readlines("failed_test") : Dir["spec/features/*.rb"]
  end

  def wait_for_process_to_finish(pid_list)
    for i in 0...pid_list.size do
      begin
        Process.getpgid(pid_list[i])
      rescue Errno::ESRCH
        pid_list.delete_at(i)
        break
      end
      sleep 3
    end
  end

  def cleanup
    delete_file("log")
    delete_file("failed_tests")
  end

  def delete_file(file_path)
    File.delete (file_path) if File.exist?(file_path)
  end

  def create_failed_test_list
    file=File.open("log", 'r')

    failed_test=[]
    file.each do |line|
      if line.include? 'rspec ./spec/features/'
        failed_test<<line.split(":")[0].gsub('rspec ./', '')
      end
    end
    failed_test.uniq!
    File.open("failed_test", 'w').puts failed_test if failed_test.length > 0
  end
end

ParallelRun.new.execute_parallel_run
