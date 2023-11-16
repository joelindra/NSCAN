# Check if colorize gem is installed
unless Gem::Specification.find_all_by_name('colorize').any?
    puts "Installing 'colorize' gem..."
    system('gem install colorize')
    Gem.clear_paths
  end
  
  # Load the colorize gem
  require 'colorize'
  require 'fileutils'
  
  def run_nmap_scan(domain)
    output_folder = "Results"
    FileUtils.mkdir_p(output_folder) unless Dir.exist?(output_folder)
    output_file = File.join(output_folder, "#{domain}_scan.txt")
    command = "nmap -sV -F -sS -T4 #{domain} -oN #{output_file}"
    system(command)
  end
  
  # Colored and stylized prompt
  puts ""
  puts "[Created By Anonre]".colorize(:yellow)
  prompt = "" + "[ 1 ]".colorize(:yellow) + " Scan a single target domain\n" +
           "[ 2 ]".colorize(:yellow) + " Scan a list of domains from a file\n" +
           "Enter your choice: "
  print prompt
  
  begin
    user_choice = gets.chomp
  
    if user_choice == '1'
      # Single target domain
      print "Enter the target domain: "
      target_domain = gets.chomp
      run_nmap_scan(target_domain)
      puts "Scan completed for domain: #{target_domain}"
    elsif user_choice == '2'
      # File input for domain list
      print "Enter the file path containing the list of target domains: "
      file_path = gets.chomp
  
      begin
        domains = File.readlines(file_path, chomp: true)
  
        domains.each_with_index do |domain, index|
          run_nmap_scan(domain)
          puts "Scan completed for domain #{index + 1}: #{domain}"
        end
  
        puts "Scanning completed for all domains."
      rescue Errno::ENOENT
        puts "File not found. Please provide a valid file path."
      end
    else
      puts "Invalid choice. Please enter either '1' or '2'."
    end
  rescue Interrupt
    puts "\nScanning interrupted by the user."
  end
  
