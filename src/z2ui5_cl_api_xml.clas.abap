"! Generic UI5 XML view builder - translate a UI5 XML view 1:1 by method
"! chaining. Each node is one instance; navigate the tree with:
"!   tag  - add a child control/aggregation and DESCEND into it (returns child)
"!   leaf - add a child but STAY on the current node (returns the same node)
"!   up   - ASCEND to the parent (returns parent)
"!   attr - set one attribute (returns the same node)
"! Element = n (name), namespace = ns (e.g. `sap.f`), attributes = a (table of
"! n/v). Namespaces are collected and declared once on the root <mvc:View>.
CLASS z2ui5_cl_api_xml DEFINITION PUBLIC CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_s_attr,
        n TYPE string,
        v TYPE string,
      END OF ty_s_attr.
    TYPES ty_t_attr TYPE STANDARD TABLE OF ty_s_attr WITH DEFAULT KEY.

    CLASS-METHODS factory
      IMPORTING
        default_ns    TYPE string DEFAULT `sap.m`
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS tag
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

    METHODS up
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
    DATA t_ns   TYPE ty_t_attr.

    METHODS add
      IMPORTING
        n             TYPE string
        ns            TYPE string
        a             TYPE ty_t_attr
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_api_xml.

    METHODS reg_ns
      IMPORTING
        lib           TYPE string
      RETURNING
        VALUE(result) TYPE string.

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

  METHOD factory.

    result = NEW #( ).
    result->root = result.
    result->name = `View`.
    result->prefix = `mvc`.
    result->t_ns = VALUE #( ( n = `` v = default_ns )
                           ( n = `mvc` v = `sap.ui.core.mvc` ) ).

  ENDMETHOD.


  METHOD add.

    result = NEW #( ).
    result->root = root.
    result->parent = me.
    result->name = n.
    result->t_attr = a.
    IF ns IS NOT INITIAL.
      result->prefix = reg_ns( ns ).
    ENDIF.
    APPEND result TO t_child.

  ENDMETHOD.


  METHOD tag.

    result = add( n  = n
                  ns = ns
                  a  = a ).

  ENDMETHOD.


  METHOD leaf.

    add( n  = n
         ns = ns
         a  = a ).
    result = me.

  ENDMETHOD.


  METHOD attr.

    APPEND VALUE #( n = n v = v ) TO t_attr.
    result = me.

  ENDMETHOD.


  METHOD up.

    result = parent.

  ENDMETHOD.


  METHOD reg_ns.

    DATA(map) = VALUE ty_t_attr(
        ( n = `sap.f`           v = `f` )
        ( n = `sap.uxap`        v = `uxap` )
        ( n = `sap.tnt`         v = `tnt` )
        ( n = `sap.ui.layout`   v = `l` )
        ( n = `sap.ui.core`     v = `core` )
        ( n = `sap.ui.table`    v = `table` )
        ( n = `sap.ui.unified`  v = `u` )
        ( n = `sap.ui.core.mvc` v = `mvc` ) ).

    result = VALUE #( map[ n = lib ]-v OPTIONAL ).
    IF result IS INITIAL.
      SPLIT lib AT `.` INTO TABLE DATA(t_seg).
      result = t_seg[ lines( t_seg ) ].
    ENDIF.

    IF NOT line_exists( root->t_ns[ n = result ] ).
      APPEND VALUE #( n = result v = lib ) TO root->t_ns.
    ENDIF.

  ENDMETHOD.


  METHOD render.

    DATA(tag_name) = COND string( WHEN prefix IS INITIAL THEN name ELSE |{ prefix }:{ name }| ).

    DATA(attrs) = ``.
    IF me = root.
      LOOP AT t_ns INTO DATA(ns).
        attrs = COND string( WHEN ns-n IS INITIAL THEN |{ attrs } xmlns="{ ns-v }"|
                             ELSE |{ attrs } xmlns:{ ns-n }="{ ns-v }"| ).
      ENDLOOP.
    ENDIF.
    LOOP AT t_attr INTO DATA(at).
      attrs = |{ attrs } { at-n }="{ xml_escape( at-v ) }"|.
    ENDLOOP.

    IF t_child IS INITIAL.
      result = |<{ tag_name }{ attrs }/>|.
      RETURN.
    ENDIF.

    DATA(inner) = ``.
    LOOP AT t_child INTO DATA(child).
      inner = |{ inner }{ child->render( ) }|.
    ENDLOOP.
    result = |<{ tag_name }{ attrs }>{ inner }</{ tag_name }>|.

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
