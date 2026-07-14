"! Generic UI5 XML view builder - translate a UI5 XML view 1:1 by method
"! chaining. Navigate the tree with (all verbs 4 chars, so chains align):
"!   open  - add a child control/aggregation and DESCEND into it (returns child)
"!   leaf  - add a childless control but STAY on the current node (returns same)
"!   shut  - ASCEND to the parent (returns parent)
"!   attr  - set one attribute (returns the same node)
"! Element = n (name), namespace prefix = ns (e.g. `f`, `core`, `l`), attributes
"! = a (table of n/v). The root <mvc:View> and its xmlns declarations are written
"! by hand: pass them to factory( ) as attributes, exactly like a real UI5 view.
"! For a boolean property fed from an ABAP variable, wrap it with as_bool( ).
CLASS z2ui5_cl_api_xml DEFINITION PUBLIC CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_s_attr,
        n TYPE string,
        v TYPE string,
      END OF ty_s_attr.
    TYPES ty_t_attr TYPE STANDARD TABLE OF ty_s_attr WITH DEFAULT KEY.

    "! render an ABAP boolean as the UI5 attribute value `true` / `false`,
    "! e.g. a = VALUE #( ( n = `visible` v = z2ui5_cl_api_xml=>as_bool( flag ) ) )
    CLASS-METHODS as_bool
      IMPORTING
        val           TYPE abap_bool
      RETURNING
        VALUE(result) TYPE string.

    "! returns an empty builder root; open the <mvc:View> and declare the xmlns
    "! namespaces yourself, exactly like any other control:
    "!   DATA(view) = z2ui5_cl_api_xml=>factory( ).
    "!   view->open( n = `View` ns = `mvc`
    "!               a = VALUE #( ( n = `xmlns` v = `sap.m` ) ... ) ) ...
    CLASS-METHODS factory
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS open
      IMPORTING
        n             TYPE string
        ns            TYPE string OPTIONAL
        a             TYPE ty_t_attr OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS leaf
      IMPORTING
        n             TYPE string
        ns            TYPE string OPTIONAL
        a             TYPE ty_t_attr OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS attr
      IMPORTING
        n             TYPE string
        v             TYPE string
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS shut
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS stringify
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.
    TYPES ty_t_node TYPE STANDARD TABLE OF REF TO z2ui5_cl_api_xml WITH DEFAULT KEY.

    DATA name   TYPE string.
    DATA prefix TYPE string.
    DATA t_attr TYPE ty_t_attr.
    DATA t_child TYPE ty_t_node.
    DATA parent TYPE REF TO z2ui5_cl_api_xml.
    DATA root   TYPE REF TO z2ui5_cl_api_xml.

    METHODS elem
      IMPORTING
        n             TYPE string
        ns            TYPE string
        a             TYPE ty_t_attr
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS render
      RETURNING
        VALUE(result) TYPE string.

    METHODS xml_escape
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_xml IMPLEMENTATION.

  METHOD as_bool.

    result = COND #( WHEN val = abap_true THEN `true` ELSE `false` ).

  ENDMETHOD.


  METHOD factory.

    result = NEW #( ).
    result->root = result.

  ENDMETHOD.


  METHOD elem.

    result = NEW #( ).
    result->root = root.
    result->parent = me.
    result->name = n.
    result->prefix = ns.
    result->t_attr = a.
    APPEND result TO t_child.

  ENDMETHOD.


  METHOD open.

    result = elem( n  = n
                   ns = ns
                   a  = a ).

  ENDMETHOD.


  METHOD leaf.

    elem( n  = n
          ns = ns
          a  = a ).
    result = me.

  ENDMETHOD.


  METHOD attr.

    APPEND VALUE #( n = n v = v ) TO t_attr.
    result = me.

  ENDMETHOD.


  METHOD shut.

    result = parent.

  ENDMETHOD.


  METHOD render.

    DATA(inner) = ``.
    LOOP AT t_child INTO DATA(child).
      inner = |{ inner }{ child->render( ) }|.
    ENDLOOP.

    IF name IS INITIAL.       " empty builder root - render only the children
      result = inner.
      RETURN.
    ENDIF.

    DATA(qname) = COND string( WHEN prefix IS INITIAL THEN name ELSE |{ prefix }:{ name }| ).
    DATA(attrs) = ``.
    LOOP AT t_attr INTO DATA(at).
      attrs = |{ attrs } { at-n }="{ xml_escape( at-v ) }"|.
    ENDLOOP.

    IF t_child IS INITIAL.
      result = |<{ qname }{ attrs }/>|.
    ELSE.
      result = |<{ qname }{ attrs }>{ inner }</{ qname }>|.
    ENDIF.

  ENDMETHOD.


  METHOD xml_escape.

    result = val.
    result = replace( val = result sub = `&` with = `&amp;` occ = 0 ).
    result = replace( val = result sub = `<` with = `&lt;` occ = 0 ).
    result = replace( val = result sub = `>` with = `&gt;` occ = 0 ).
    result = replace( val = result sub = `"` with = `&quot;` occ = 0 ).

  ENDMETHOD.


  METHOD stringify.

    result = root->render( ).

  ENDMETHOD.

ENDCLASS.
