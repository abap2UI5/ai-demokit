" @keywords objectpagelayout object layout sap.uxap objectpagexml objectpageheader button verticallayout link horizontallayout label objectpagesection
" @summary An ObjectPageLayout declared in one XML view - header title, header content and five sections whose blocks come from four different block namespaces - rather than assembled in a controller.
CLASS z2ui5_cl_smpc_app_597 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the ObjectPageState model, folded onto root fields: the two section titles
    " and the four subsection title / mode pairs the view binds
    DATA sec0_title      TYPE string.
    DATA sec0_sub0_title TYPE string.
    DATA sec0_sub0_mode  TYPE string.
    DATA sec0_sub1_title TYPE string.
    DATA sec0_sub1_mode  TYPE string.
    DATA sec1_title      TYPE string.
    DATA sec1_sub0_title TYPE string.
    DATA sec1_sub0_mode  TYPE string.
    DATA sec1_sub1_title TYPE string.
    DATA sec1_sub1_mode  TYPE string.

    " the MyEmployee record the GeneralInfo blocks map onto
    DATA emp_name     TYPE string.
    DATA emp_job      TYPE string.
    DATA emp_location TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_597 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent). Four of this sample's block
    " types are NOT in the demo kit archive - they live in UI5's test resources
    " (sap.uxap.testblocks.*) or in a Headers sample that is not published - so
    " their content is improvised; see the sidecar, which says exactly which
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `action pressed !` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `action pressed !` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:forms`  v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageHeader`
                    )->a( n = `objectImageURI` v = `https://sdk.openui5.org/test-resources/sap/uxap/images/imageID_275314.png`
                    )->a( n = `objectTitle`    v = `Denise Smith`
                    )->a( n = `objectSubtitle` v = `Senior UI Developer`

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://pull-down`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `tooltip` v = `show section`
                            )->a( n = `press`   v = client->_event( `SHOW_CURRENT_SECTION` )
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://show`
                            )->a( n = `type`    v = `Emphasized`
                            )->a( n = `tooltip` v = `show state`
                            )->a( n = `press`   v = client->_event( `SHOW_STATE` )
                    )->end(
                )->end(
            )->end(

            )->ele( `headerContent`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Link` ns = `m`
                        )->a( n = `text` v = `+33 6 4512 5158`
                    )->tag( n = `Link` ns = `m`
                        )->a( n = `text` v = `DeniseSmith@sap.com`

                    )->ele( n = `HorizontalLayout` ns = `layout`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text`   v = `twitter`
                            )->a( n = `target` v = `_blank`
                        )->tag( n = `Link` ns = `m`
                            )->a( n = `text`   v = `LinkedIn`
                            )->a( n = `target` v = `_blank`
                    )->end(
                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `Personal description`

                    )->ele( n = `VerticalLayout` ns = `layout`
                        )->a( n = `id` v = `headerDescription`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Personal description (2)`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Personal description (3)`
                        )->tag( n = `Label` ns = `m`
                            )->a( n = `text` v = `Personal description (4)`
                    )->end(
                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `id`   v = `headerRole`
                        )->a( n = `text` v = `Role Specific info`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `id`   v = `headerRole1`
                        )->a( n = `text` v = `Role Specific info 1`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `id`   v = `headerRole2`
                        )->a( n = `text` v = `Role Specific info 2`
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = client->_bind( sec0_title )

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = client->_bind( sec0_sub0_title )
                            )->a( n = `mode`           v = client->_bind( sec0_sub0_mode )
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                " bl:GeneralInfo (improvised - see sidecar), with the
                                " MyEmployee record its ModelMapping names
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `General Info`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Name`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_name )
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_job )
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Location`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_location )
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = client->_bind( sec0_sub1_title )
                            )->a( n = `mode`           v = client->_bind( sec0_sub1_mode )
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `actions`
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `icon`    v = `sap-icon://action`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `tooltip` v = `action`
                                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp1 )
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `icon`    v = `sap-icon://edit`
                                    )->a( n = `type`    v = `Transparent`
                                    )->a( n = `tooltip` v = `edit`
                                    )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp2 )
                            )->end(

                            )->ele( `blocks`
                                " sample:MultiViewBlock, its Collapsed view
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                )->end(

                                " sample:MultiViewBlock, its Collapsed view
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                )->end(
                            )->end(

                            )->ele( `moreBlocks`
                                " sample:MultiViewBlock, its Collapsed view
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = client->_bind( sec1_title )

                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = client->_bind( sec1_sub0_title )
                            )->a( n = `mode`           v = client->_bind( sec1_sub0_mode )
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                " bl:GeneralInfo (improvised - see sidecar), the same
                                " block a second time, with the same ModelMapping
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `General Info`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Name`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_name )
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_job )
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Location`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_location )
                                )->end(
                            )->end(
                        )->end(

                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = client->_bind( sec1_sub1_title )
                            )->a( n = `mode`           v = client->_bind( sec1_sub1_mode )
                            )->a( n = `titleUppercase` v = `false`

                            )->ele( `blocks`
                                " edit:SimpleEdit (improvised - see sidecar)
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `true`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Simple Edit`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Name`
                                    )->tag( n = `Input` ns = `m`
                                        )->a( n = `value` v = client->_bind( emp_name )
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job`
                                    )->tag( n = `Input` ns = `m`
                                        )->a( n = `value` v = client->_bind( emp_job )
                                )->end(

                                " mb:MixedBlock (improvised - see sidecar)
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `editable` v = `true`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Title` ns = `core`
                                        )->a( n = `text` v = `Mixed Block`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Location`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = client->_bind( emp_location )
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Job`
                                    )->tag( n = `Input` ns = `m`
                                        )->a( n = `value` v = client->_bind( emp_job )
                                )->end(
                            )->end(

                            )->ele( `moreBlocks`
                                " sample:MultiViewBlock, its Collapsed view
                                )->ele( n = `SimpleForm` ns = `forms`
                                    )->a( n = `title`    v = `Location`
                                    )->a( n = `editable` v = `false`
                                    )->a( n = `layout`   v = `ColumnLayout`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Country`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `France`
                                    )->tag( n = `Label` ns = `m`
                                        )->a( n = `text` v = `Subsidiary`
                                    )->tag( n = `Text` ns = `m`
                                        )->a( n = `text` v = `SAP France`
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SHOW_CURRENT_SECTION`.
        " showCurrentSection toasts getScrollingSectionId( ) - the sample's own
        " comment calls it "the only property that is not really bindable", and a
        " thin frontend never sees it, so the toast reports what the page IS
        client->message_toast_display( |you are currently scrolling { sec0_title }| ).

      WHEN `SHOW_STATE`.
        " showObjectPageState dumps the whole state model as pretty JSON
        client->message_toast_display(
          |ObjectPageLayout current state:\r\n| &&
          |\{\n|                                                                    &&
          |    "scrollingSectionId": "",\n|                                         &&
          |    "sections": [\n|                                                     &&
          |        \{\n|                                                            &&
          |            "title": "{ sec0_title }",\n|                                &&
          |            "subsections": [\n|                                          &&
          |                \{ "title": "{ sec0_sub0_title }", "mode": "{ sec0_sub0_mode }" \},\n| &&
          |                \{ "title": "{ sec0_sub1_title }", "mode": "{ sec0_sub1_mode }" \}\n|  &&
          |            ]\n|                                                         &&
          |        \},\n|                                                           &&
          |        \{\n|                                                            &&
          |            "title": "{ sec1_title }",\n|                                &&
          |            "subsections": [\n|                                          &&
          |                \{ "title": "{ sec1_sub0_title }", "mode": "{ sec1_sub0_mode }" \},\n| &&
          |                \{ "title": "{ sec1_sub1_title }", "mode": "{ sec1_sub1_mode }" \}\n|  &&
          |            ]\n|                                                         &&
          |        \}\n|                                                            &&
          |    ]\n|                                                                 &&
          |\}| ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the ObjectPageState model the controller seeds in onInit
    sec0_title      = `my first section`.
    sec0_sub0_title = `general info`.
    sec0_sub0_mode  = `Collapsed`.
    sec0_sub1_title = `my detail info`.
    sec0_sub1_mode  = `Collapsed`.
    sec1_title      = `my second section`.
    sec1_sub0_title = `compensation`.
    sec1_sub0_mode  = `Collapsed`.
    sec1_sub1_title = `compensation details`.
    sec1_sub1_mode  = `Expanded`.

    " HRData.json has no /MyEmployee node, so the two GeneralInfo blocks render
    " empty upstream; the port seeds the first /Employee row the file does carry
    emp_name     = `Michael Adams`.
    emp_job      = `Scrum Master`.
    emp_location = `SAP France`.

  ENDMETHOD.

ENDCLASS.
