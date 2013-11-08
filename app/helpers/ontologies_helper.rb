module OntologiesHelper

  ## Provides a link or string based on the status of an ontology.
  #def get_status_text(ontology, params = {})
  #  # Don't display a link for ontologies that aren't browsable
  #  # (these are temporarily defined in environment.rb)
  #  unless $NOT_EXPLORABLE.nil?
  #    $NOT_EXPLORABLE.each do |virtual_id|
  #      if ontology.ontologyId.eql?(virtual_id.to_s)
  #        return ""
  #      end
  #    end
  #  end
  #
  #  case ontology.statusId.to_i
  #  when 1 # Ontology is parsing
  #    return "waiting to parse"
  #  when 2
  #    return "parsing"
  #  when 3 # Ontology is ready to be explored
  #    return ""
  #  when 4 # Error in parsing
  #    return "<span style='color: red;'>parsing error</span>"
  #  when 6 # Ontology is deprecated
  #    return "archived"
  #  end
  #end

  ## Provides a link or string based on the status of an ontology.
  #def get_visualize_link(ontology, params = {})
  #  case ontology.statusId.to_i
  #  when 1 # Ontology is parsing
  #    return "Waiting to Parse"
  #  when 2
  #    return "Parsing Ontology"
  #  when 3 # Ontology is ready to be explored
  #    return "<a href=\"/visualize/#{ontology.id}\">Explore</a>" if params[:path_only].nil?
  #    return "/visualize/#{ontology.id}"
  #  when 4 # Error in parsing
  #    return "Parsing Error"
  #  when 6 # Ontology is deprecated
  #    return "Archived, not available to explore"
  #  end
  #end


  def additional_details
    return "" if $ADDITIONAL_ONTOLOGY_DETAILS.nil? || $ADDITIONAL_ONTOLOGY_DETAILS[@ontology.acronym].nil?
    details = $ADDITIONAL_ONTOLOGY_DETAILS[@ontology.acronym]
    html = []
    details.each do |title, value|
      html << content_tag(:tr) do
        [content_tag(:th, title), content_tag(:td, value)].join("")
      end
    end
    html.join("")
  end

  ## Provides a link for an ontology based on where it's hosted (Local or remote)
  #def get_download_link(ontology)
  #  # Don't display a link for ontologies that aren't downloadable
  #  # (these are temporarily defined in environment.rb)
  #  unless $NOT_DOWNLOADABLE.nil?
  #    $NOT_DOWNLOADABLE.each do |virtual_id|
  #      if ontology.ontologyId.eql?(virtual_id.to_s)
  #        return "<span style='cursor: help;' title='Ontology download is unavailable because of licensing restrictions'>Unavailable</span>"
  #      end
  #    end
  #  end
  #  if ontology.summaryOnly
  #    return "<a href=\"#{ontology.homepage}\" target=\"_blank\">Ontology Homepage</a>"
  #  else
  #    return "<a href=\"#{DataAccess.download(ontology.id)}\" target=\"_blank\">Ontology</a>"
  #  end
  #end

  #def get_view_ontology_version(view_on_ontology_id)
  #  return DataAccess.getOntology(view_on_ontology_id).versionNumber
  #end

  ## Generates a properly-formatted link for diffs
  #def get_diffs_link(diffs, versions, current_version, index)
  #  currID = current_version.id.to_i
  #  # Search for a previous ontology version, with statusId == 3,
  #  # within the prior two versions of the ontology. The list of
  #  # versions is sorted by versionID, descending.
  #  prevID = nil
  #  versions[index + 1, 2].each do |v|
  #    prevID = v.id.to_i if v.statusId.to_i == 3
  #    break if not prevID.nil?
  #  end
  #  # Exit when there is no suitable previous version in the recent history.
  #  return "" if prevID.nil?
  #  # Find a 'diff' pair to match the current and previous versions, or vice versa.
  #  for diff in diffs
  #    if currID.eql?(diff[0].to_i) && prevID.eql?(diff[1].to_i)
  #      new, old = diff[0..1]
  #    elsif currID.eql?(diff[1].to_i) && prevID.eql?(diff[0].to_i)
  #      new, old = diff[0..1].reverse
  #    else
  #      next
  #    end
  #    #return "<a href='#{$LEGACY_REST_URL}/diffs/download/#{new}/#{old}?format=xml' target='_blank'>Diff</a>"
  #    return "<a href='#{DataAccess.getDiffDownloadURI(new, old)}' target='_blank'>Diff</a>"
  #  end
  #  return ""
  #end

  ## Generates an array for use with version drop-down lists
  #def get_versions_array_for_select(ontology_version_id)
  #  ontology = DataAccess.getOntology(ontology_version_id)
  #  ont_versions = DataAccess.getOntologyVersions(ontology.ontologyId).sort! {|ont_a,ont_b| ont_b.internalVersion.to_i <=> ont_a.internalVersion.to_i}
  #  ont_versions_array = []
  #  ont_versions.each {|ont| ont_versions_array << [ ont.versionNumber, ont.id ] }
  #  return ont_versions_array
  #end

  #def get_ont_icons(ontology)
  #  mappings_count = DataAccess.getMappingCountOntologiesHash
  #  mappings_count = mappings_count[ontology.ontologyId].to_i
  #  notes_count = DataAccess.getNotesCounts
  #  notes_count = notes_count[ontology.ontologyId].to_i
  #
  #  formatting_options = { :thousand => "K", :million => "M", :billion => "B" }
  #
  #  mappings_count_formatted = (mappings_count.nil? || mappings_count == 0) ? "" : number_to_human(mappings_count, :precision => 0, :units => formatting_options).gsub(" ", "")
  #  notes_count_formatted = (notes_count.nil? || notes_count == 0) ? "" : number_to_human(notes_count, :units => formatting_options).gsub(" ", "")
  #
  #  links = ""
  #  links << "<a class='ont_icons' href=''>T</a>"
  #  links << "<a class='ont_icons' href=''>M<span class='ont_counts'>#{mappings_count_formatted}</span></a>"
  #  links << "<a class='ont_icons' href=''>N<span class='ont_counts'>#{notes_count_formatted}</span></a>"
  #end

  def count_links(ont_acronym, page_name='summary', count=0)
    ont_url = "/ontologies/#{ont_acronym}"
    if count.nil? || count == 0
      return "0"
      #return "<a href='#{ont_url}/?p=summary'>0</a>"
    else
      return "<a href='#{ont_url}/?p=#{page_name}'>#{number_with_delimiter(count, :delimiter => ',')}</a>"
    end
  end

  def classes_link(ontology, count)
    return "0" if (ontology.summaryOnly || count.nil? || count == 0)
    return count_links(ontology.ontology.acronym, 'classes', count)
  end

  # Creates a link based on the status of an ontology submission
  def download_link(submission)
    if submission.ontology.summaryOnly
      if submission.homepage.nil?
        link = 'N/A'
      else
        uri = submission.homepage
        link = "<a href='#{uri}'>Home Page</a>"
      end
    else
      uri = submission.id + "/download?apikey=#{get_apikey}"
      link = "<a href='#{uri}' target='_blank'>Ontology</a>"
      unless submission.diffFilePath.nil?
        uri = submission.id + "/download_diff?apikey=#{get_apikey}"
        link = link + " | <a href='#{uri}' target='_blank'>Diff</a>"
      end
    end
    return link
  end

  def mappings_link(ontology, count)
    return "0" if (ontology.summaryOnly || count.nil? || count == 0)
    return count_links(ontology.ontology.acronym, 'mappings', count)
  end

  def notes_link(ontology, count)
    #count = 0 if ontology.summaryOnly
    return count_links(ontology.ontology.acronym, 'notes', count)
  end

  # Creates a link based on the status of an ontology submission
  def status_link(submission, latest=false)
    version_text = submission.version.nil? || submission.version.length == 0 ? "unknown" : submission.version
    status_text = " <span class='ontology_submission_status'>" + submission_status2string(submission) + "</span>"
    if submission.ontology.summaryOnly || latest==false
      version_link = version_text
    else
      version_link = "<a href='/ontologies/#{submission.ontology.acronym}?p=classes'>#{version_text}</a>"
    end
    return version_link + status_text
  end

  def submission_status2string(sub)
    # Massage the submission status into a UI string
    #submission status values, from:
    # https://github.com/ncbo/ontologies_linked_data/blob/master/lib/ontologies_linked_data/models/submission_status.rb
    # "UPLOADED", "RDF", "RDF_LABELS", "INDEXED", "METRICS", "ANNOTATOR", "ARCHIVED"  and 'ERROR_*' for each.
    # Strip the URI prefix from the status codes (works even if they are not URIs)
    # The order of the codes must be assumed to be random, it is not an entirely
    # predictable sequence of ontology processing stages.
    codes = sub.submissionStatus.map {|s| s.split('/').last }
    errors = codes.map {|c| c if c.start_with? 'ERROR'}.compact
    status = []
    status.push('Parsed') if (codes.include? 'RDF') && (codes.include? 'RDF_LABELS')
    if not errors.empty?
      status.concat errors
      # Forget about other status codes.
    else
      # The order of this array imposes an oder on the UI status code string
      status_list = [ "INDEXED", "METRICS", "ANNOTATOR", "ARCHIVED" ]
      status_list.insert(0, 'UPLOADED') unless status.include?('Parsed')
      status_list.each do |c|
        status.push(c.capitalize) if codes.include? c
      end
    end
    return '' if status.empty?
    return '(' + status.join(', ') + ')'
  end

  # Link for private/public/licensed ontologies
  def visibility_link(ontology)
    ont_url = "/ontologies/#{ontology.acronym}"  # 'ontology' is NOT a submission here
    page_name = 'summary'  # default ontology page view for visibility link
    link_name = 'Public'   # default ontology visibility
    if ontology.summaryOnly
      link_name = 'Summary Only'
    elsif ontology.private?
      link_name = 'Private'
    elsif ontology.licensed?
      link_name = 'Licensed'
    end
    return "<a href='#{ont_url}/?p=#{page_name}'>#{link_name}</a>"
  end


end
