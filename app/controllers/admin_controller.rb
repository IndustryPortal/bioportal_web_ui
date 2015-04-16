require 'JSON'

class AdminController < ApplicationController
  layout 'ontology'
  before_action :cache_setup

  DEBUG_BLACKLIST = [:"$,", :$ADDITIONAL_ONTOLOGY_DETAILS, :$rdebug_state, :$PROGRAM_NAME, :$LOADED_FEATURES, :$KCODE, :$-i, :$rails_rake_task, :$$, :$gems_build_rake_task, :$daemons_stop_proc, :$VERBOSE, :$DAEMONS_ARGV, :$daemons_sigterm, :$DEBUG_BEFORE, :$stdout, :$-0, :$-l, :$-I, :$DEBUG, :$', :$gems_rake_task, :$_, :$CODERAY_DEBUG, :$-F, :$", :$0, :$=, :$FILENAME, :$?, :$!, :$rdebug_in_irb, :$-K, :$TESTING, :$fileutils_rb_have_lchmod, :$EMAIL_EXCEPTIONS, :$binding, :$-v, :$>, :$SAFE, :$/, :$fileutils_rb_have_lchown, :$-p, :$-W, :$:, :$__dbg_interface, :$stderr, :$\, :$&, :$<, :$debug, :$;, :$~, :$-a, :$DEBUG_RDOC, :$CGI_ENV, :$LOAD_PATH, :$-d, :$*, :$., :$-w, :$+, :$@, :$`, :$stdin, :$1, :$2, :$3, :$4, :$5, :$6, :$7, :$8, :$9]
  PROBLEM_ONTOLOGIES_URI = "/admin/problem_ontologies"
  ONTOLOGIES_URI = "/admin/report"




  def index
    if session[:user].nil? || !session[:user].admin?
      redirect_to :controller => 'login', :action => 'index', :redirect => '/admin'
    else
      start = Time.now
      form_data = Hash.new

      if params["problem_ontologies"]
        ontologies_data = LinkedData::Client::HTTP.get(PROBLEM_ONTOLOGIES_URI, form_data, raw: true)
      else
        ontologies_data = LinkedData::Client::HTTP.get(ONTOLOGIES_URI, form_data, raw: true)
      end
      @ontologies = JSON.parse(ontologies_data)

      LOG.add :debug, "Retrieved #{@ontologies.length} ontologies: #{Time.now - start}s"
      # render json: problem_ontologies
      render action: "index"
    end

    # globals =  global_variables - DEBUG_BLACKLIST
    # @globals = {}
    # globals.each {|g| @globals[g.to_s] = eval(g.to_s)}
  end


  def ontologies
    @ontology = LinkedData::Client::Models::Ontology.get(CGI.unescape(params["id"])) rescue nil
    @ontology = LinkedData::Client::Models::Ontology.find_by_acronym(params["id"]).first unless @ontology
    puts "This is a sumbmissions controller for #{params["id"]}"
    render action: "submissions"
  end


  def clearcache
    if @cache.respond_to?(:flush_all)
      begin
        @cache.flush_all
      rescue
        @status = "There was a problem flushing the cache"
      end

      @status = "Cache successfully flushed"
    else
      @status = "Error: the cache does not respond to the `flush_all` command"
    end
    render :partial => 'status'
  end

  def resetcache
    if @cache.respond_to?(:reset)
      begin
        @cache.reset
      rescue
        @status = "There was a problem reseting the cache connection"
      end

      @status = "Cache connection successfully reset"
    else
      @status = "Error: the cache does not respond to the `reset` command"
    end
    render :partial => 'status'
  end

  private

  def cache_setup
    @cache = Rails.cache.instance_variable_get("@data")
  end

end
