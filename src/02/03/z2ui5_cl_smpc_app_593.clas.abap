" @keywords objectpagelayout lazyloading sap.uxap objectpagesection objectpagesubsection modelmapping blockbase employmentblockjob
CLASS z2ui5_cl_smpc_app_593 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA emp1_name TYPE string.
    DATA emp1_job  TYPE string.
    DATA emp2_name TYPE string.
    DATA emp2_job  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_593 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent): eleven sections, each with
    " the SAME employment:EmploymentBlockJob - which is the sample, a page heavy
    " enough for enableLazyLoading to be worth watching
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                  v = `ObjectPageLayout`
            )->a( n = `enableLazyLoading`   v = `true`
            )->a( n = `upperCaseAnchorBar`  v = `false`
            )->a( n = `headerContentPinned` v = `true`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `heading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `ObjectPage with LazyLoading`
                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `ObjectPage with LazyLoading`
                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Copy`
                        )->tag( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`
                    )->end(
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 1`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 2`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 3`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 4`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 5`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 6`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 7`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 8`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 9`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 10`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 11`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`

                                " employment:EmploymentBlockJob inlined with its Collapsed
                                " view (the block's initial mode); the empN> models fold
                                " onto the default-model root
                                )->ele( n = `Grid` ns = `layout`
                                    )->a( n = `defaultSpan` v = `L4 M6 S12`
                                    )->a( n = `hSpacing`    v = `0`
                                    )->a( n = `width`       v = `100%`

                                    )->ele( n = `content` ns = `layout`
                                        )->ele( n = `VerticalLayout` ns = `layout`
                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `content` ns = `layout`
                                                        )->ele( n = `VerticalLayout` ns = `layout`
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_name )
                                                            )->tag( n = `Label` ns = `m`
                                                                )->a( n = `text` v = client->_bind( emp1_job )

                                                            )->ele( n = `layoutData` ns = `layout`
                                                                )->tag( n = `GridData` ns = `layout`
                                                                    )->a( n = `span` v = `L12 M12 S12`

                                                            )->end(
                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(

                                            )->ele( n = `layoutData` ns = `layout`
                                                )->tag( n = `GridData` ns = `layout`
                                                    )->a( n = `linebreak` v = `true`

                                            )->end(

                                            )->ele( n = `HorizontalLayout` ns = `layout`
                                                )->ele( n = `Grid` ns = `layout`
                                                    )->a( n = `defaultSpan` v = `L4 M4 S4`
                                                    )->a( n = `hSpacing`    v = `0`
                                                    )->a( n = `width`       v = `100%`

                                                    )->ele( n = `VerticalLayout` ns = `layout`
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_name )
                                                        )->tag( n = `Label` ns = `m`
                                                            )->a( n = `text` v = client->_bind( emp2_job )

                                                        )->ele( n = `layoutData` ns = `layout`
                                                            )->tag( n = `GridData` ns = `layout`
                                                                )->a( n = `span` v = `L12 M12 S12`

                                                        )->end(
                                                    )->end(
                                                )->end(
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " ObjectPageModel>/Employee rows 0 and 1, the two records the block's
    " uxap:ModelMapping elements map onto the internal models emp1> / emp2>
    emp1_name = `Michael Adams`.
    emp1_job  = `Scrum Master`.
    emp2_name = `John Miller`.
    emp2_job  = `Product Owner`.

  ENDMETHOD.

ENDCLASS.
