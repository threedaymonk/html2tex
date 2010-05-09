class HTML2TeX
  module TeX
    def tex(name, param=nil)
      directive = "\\" + name.to_s
      directive << "{" << tex_escape(param) << "}" if param
      directive
    end

    def tex_escape(s)
      return nil if s.nil?
      s.gsub(/[\\{}$&#%^_~]/, '\\\\\\0')
    end
  end
end
