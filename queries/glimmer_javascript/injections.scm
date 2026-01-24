; inherits: ecma

; Ember Unified <template> syntax
; e.g.: <template><SomeComponent @arg={{double @value}} /></template>
;
; include-children is needed for highlighting css and scripts
((glimmer_template) @injection.content
  (#set! injection.language "glimmer")
  (#set! injection.include-children))
