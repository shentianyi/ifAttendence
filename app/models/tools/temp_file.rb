#encoding: utf-8
class TempFile
  attr_accessor :data, :oriName, :desName, :path
  
  def initialize( fileName, fileData ) 
      @data = fileData
      @oriName = fileName
      @desName = UUID.generate + @oriName
      @path = File.join($TempFileDir,@desName)
      File.open( @path,'wb') do |f|
        f.write(@data.read)
      end
  end

end