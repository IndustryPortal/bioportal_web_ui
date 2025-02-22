// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require bioportal
//= require admin/licenses
//= require bp_ajax_controller
//= require bp_ontology_viewer
//= require bp_reviews
//= require bp_notes
//= require bp_ontolobridge
//= require bp_form_complete
//= require bp_analytics
//= require bp_user_intention_survey
//= require bp_search
//= require bp_mappings
//= require bp_admin
//= require bp_recommender
//= require bp_property_tree
//= require home
//= require fair_score
//= require_tree ./helpers
//= require_tree ./components
//= require ontologies
//= require projects
//= require submissions
//= require tooltipster.bundle.min
//= require application_esbuild
customElements.define('data-table-loader', DataTableLoader );
customElements.define('data-table', DataTable );
customElements.define('instances-table', InstancesTable );


