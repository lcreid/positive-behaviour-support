namespace :db do
  desc "Back up the current database using mysqldump (only production and staging)."
  task :backup => :environment do
    require 'fileutils'
    
    logger = Logger.new(STDOUT)
    
    # Set the variables
    db = "pbs_" + Rails.env
    time = Time.new.strftime '%Y%m%d%H%M%S'
    backup_path = File.expand_path("~/backups")
    backup_file = File.join(backup_path, "backup_#{db}_#{time}")
    
    FileUtils.mkpath(backup_path) unless Dir.exists?(backup_path)
    
    # Back up
    system "mysqldump --single-transaction #{db} | gzip > #{backup_file}"
    
    # Clean up old backups.
    log_file = 'log/backup.log'
    backups = Dir.glob(File.join(backup_path, "backup_*")).sort # Newest at end
    backups[0..-6].each do |f|  # Keep max five backups
      File.delete(f)
      logger.info "Deleted old backup #{f}"
    end
    
    unless ! File.exists?(log_file) || File.size(log_file) < 1000000000
      target = log_file + time
      File.rename log_file, target
      system "gzip #{target}" 
      logger.info "Zipped backup log #{target}"
    end
  end # if ['production', 'staging'].include?(Rails.env)
end

