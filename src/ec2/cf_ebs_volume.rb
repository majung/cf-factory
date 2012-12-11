require 'base/cf_base'
class CfEbsVolume
  include CfBase  
  
  def initialize(name, availability_zone, options = {})
    @name = name
    @availability_zone = availability_zone
    
    @size = options[:size]
    @snapshot_id = options[:snapshot_id]
    @iops = options[:iops]
    @volume_type = options[:volume_type]
    set_deletion_policy("Delete")
  end

  def self.create_normal(name, availability_zone, size)
    CfEbsVolume.new(name, availability_zone, {:size => size}) 
  end
  
  def self.create_piops(name, availability_zone, size, iops)
    CfEbsVolume.new(name, availability_zone, {:size => size, :volume_type => "io1", :iops => iops})
  end
  
  def self.create_from_snapshot(name, availability_zone, snapshot_id)
    CfEbsVolume.new(name, availability_zone, {:snapshot_id => snapshot_id})
  end
  
  def set_deletion_policy(deletion_policy)
    @deletion_policy = deletion_policy
  end
          
  def get_cf_type
    "AWS::EC2::Volume"
  end
  
  def get_cf_attributes
    result = super
  end
  
  def get_cf_properties
    result = {} 
    result["AvailabilityZone"] = @availability_zone
    result["Size"] = @size unless @size.nil?
    result["VolumeType"] = @volume_type unless @volume_type.nil?
    result["SnapshotId"] = @snapshot_id unless @snapshot_id.nil?
    result["Iops"] = @iops unless @iops.nil?
    result
  end
  
end
