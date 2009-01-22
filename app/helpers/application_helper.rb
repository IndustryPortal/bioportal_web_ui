 # Methods added to this helper will be available to all templates in the application.

require 'uri'
module ApplicationHelper
  
  
  def isOwner?(id)
    unless session[:user].nil?
      if session[:user].admin?
        return true        
      elsif session[:user].id.eql?(id)
        return true
      else
        return false
      end
    end
  end
  
  def encode_param(string)
    return URI.escape(string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  
  def clean(string)
    string = string.gsub("\"",'\'')
    return string.gsub("\n",'')
  end
  
  def clean_id(string)
    new_string = string.gsub(":","").gsub("-","_").gsub(".","_")

    return new_string
  end
  
  def to_param(string)
     "#{encode_param(string.gsub(" ","_"))}"
  end
  
  def draw_note_tree(notes,key)
    output = ""
    draw_note_tree_leaves(notes,0,output,key)
    return output
  end
  
  def remove_owl_notation(string)    
    strings = string.split(":")
    if strings.size<2
      return string.titleize
    else  
      return strings[1].titleize
    end
  end
  
  
  def draw_note_tree_leaves(notes,level,output,key)

  for note in notes
    name="Anonymous"
    unless note.user.nil?
      name=note.user.username
    end
  headertext=""
  notetext=""
  if note.note_type.eql?(5)
    headertext<< "<div class=\"header\" onclick=\"toggleHide('note_body#{note.id}','');compare('#{note.id}')\">"
    notetext << " <input type=\"hidden\" id=\"note_value#{note.id}\" value=\"#{note.comment}\"> 
                  <span class=\"message\" id=\"note_text#{note.id}\">#{note.comment}</span>"
  else
    headertext<< "<div class=\"header\" onclick=\"toggleHide('note_body#{note.id}','')\">"
    
    notetext<< "<span class=\"message\" id=\"note_text#{note.id}\">#{simple_format(note.comment)}</span>"
  end
  
  
    output << "
        <div style=\"clear:both;margin-left:#{level*20}px;\">
        <div class=\"ygtvln\" style=\"float:left;\"></div>
        <div class=\"outgoing\" style=\"float:left;width:500px;\">  
          
          <div class=\"header_top\"></div>
          #{headertext}
            <div>
              <div><span class=\"sender\" style=\"float:right\">#{name} at #{note.created_at.strftime('%m/%d/%y %H:%M')}</span>
                <div class=\"sender\">#{note.type_label.titleize}: #{note.subject}</div>
              </div>
            </div>
            <div class=\"left\"></div>
            <div class=\"right\"></div>
          </div>
        
          <div name=\"hiddenNote\" id=\"note_body#{note.id}\" style=\"display:none;\">
          <div class=\"messages\">
            <div>
              <div>
               #{notetext}"
               if session[:user].nil?
                 output << "<div id=\"insert\"><a href=\"\/login?redirect=#{@ontology.to_param}\">Reply</a></div>"
               else
                output << "<div id=\"insert\"><a href=\"\#\" onclick =\"Dialog.form( document.getElementById('commentForm').innerHTML,  {height: 500, title: 'New Marginal Note', width: 800, windowParameters: {}} ); buildEditor('#{key}');document.getElementById('noteParent').value='#{note.id}';document.getElementById('note_subject#{key}').value='RE:#{note.subject}';\">Reply</a></div>"
               end
   output << "</div>
            </div>
          </div>
          <div class=\"messages_bottom\">
            <div class=\"left\"></div>
            <div class=\"right\"></div>
          </div>
          </div>
        </div>
        </div>"
        if(!note.children.nil? && note.children.size>0)
          draw_note_tree_leaves(note.children,level+1,output,key)
        end
    end
    
    
  end
  
  
  
  
  
  def draw_tree(root, id=nil,type="Menu")
    string =""  
    if id.nil?
      id = root.children.first.id
    end
    
      build_tree(root,nil,string,id)
    
    
    return string
  end

  def build_tree(node,parent,string,id)
    if parent.nil?
      draw_root = ''
    else
      draw_root = ""
    end
    
    unless node.children.nil? || node.children.length <1
      for child in node.children
      icons = ""
      if(child.note_icon)
        icons << "<img src='/images/notes_icon.png'style='vertical-align:bottom;' title='Concept Has Margin Notes'>"
      end
      if(child.map_icon)
        icons << "<img src='/images/map_icon.png' style='vertical-align:bottom;' title='Concept Has Mappings'>"
      end
    
      
        string <<"<li #{draw_root} id=\"#{child.id}\"><span>#{child.name} #{icons}</span>"
    		   		
    				if child.child_size>0 && !child.expanded
    				  string << "<ul class=\"ajax\">
  							            <li id='#{child.id}'>{url:/visualize/#{child.ontology_id}/#{child.id}?callback=children}</li>
  						            </ul>"
  				  end

    				if child.id.eql?(id)
#    				 string<< "Node#{clean_id(child.id)}.labelStyle=\"ygtvlabel-selected\"\n";	
    				end
    				string <<"</li>"
    		build_tree(child,"child",string,id)
      
      end
      
    end
        
  end
  
end
