" @keywords objectpagesubsection object sub section sap.uxap objectpagesubsectionsized objectpagelayout objectpageheader togglebutton objectpagesection button
" @summary This example shows how the size of the blocks and be either specified or automatic
CLASS z2ui5_cl_smpc_app_599 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the ConfigModel the two ToggleButtons write, folded onto root fields
    DATA subsection_layout TYPE string.
    DATA two_columns       TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_599 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " Block->content inlining (app 401/416 precedent): all 359 blocks are one
    " BlockBase, sample:InfoButton, around a single full-width Button. What the
    " BlockBase carries and the Button cannot is columnLayout - see sidecar
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.uxap`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                          v = `ObjectPageLayout`
            " both are bindable properties, so the two toggles write them
            " through the model rather than through a frontend action
            )->a( n = `useTwoColumnsForLargeScreen` v = client->_bind( two_columns )
            )->a( n = `subSectionLayout`            v = client->_bind( subsection_layout )
            )->a( n = `upperCaseAnchorBar`          v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageHeader`
                    )->a( n = `objectTitle` v = `Subsection with blocks using column layout`
                    )->ele( `actions`
                        )->tag( n = `ToggleButton` ns = `m`
                            )->a( n = `text`  v = `Use Title on the Left`
                            )->a( n = `press` v = client->_event( `TOGGLE_TITLE` )
                        )->tag( n = `ToggleButton` ns = `m`
                            )->a( n = `text`  v = `Use Two Columns Mode`
                            )->a( n = `press` v = client->_event( `TOGGLE_TWO_COLUMNS` )
                    )->end(
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `2 blocks`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton1`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton2`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton3`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton4`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-3`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton5`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton6`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton7`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton8`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 -a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton9`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton10`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton11`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton12`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `3 blocks`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton13`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton14`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton15`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton16`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton17`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton18`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton19`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton20`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton21`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton22`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton23`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton24`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2-a-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton25`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton26`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton27`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton28`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton29`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton30`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton31`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton32`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton33`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `4 blocks`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton34`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton35`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton36`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton37`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton38`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton39`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton40`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton41`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton42`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton43`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton44`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton45`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton46`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton47`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton48`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton49`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton50`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton51`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton52`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton53`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton54`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton55`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton56`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton57`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton58`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton59`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton60`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton61`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2-a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton62`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton63`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton64`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton65`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3-a-3-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton66`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton67`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton68`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton69`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `5 blocks`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton70`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton71`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton72`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton73`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton74`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2-a-a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton75`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton76`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton77`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton78`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton79`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3-a-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton80`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton81`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton82`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton83`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton84`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3-a-a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton85`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton86`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton87`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton88`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton89`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-1-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton90`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton91`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton92`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton93`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton94`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-1-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton95`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton96`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton97`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton98`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton99`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-3-a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton100`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton101`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton102`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton103`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton104`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton105`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton106`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton107`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton108`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton109`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton110`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton111`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton112`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton113`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton114`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1-a-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton115`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton116`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton117`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton118`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton119`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1-a-2-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton120`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton121`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton122`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton123`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton124`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton125`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton126`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton127`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton128`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton129`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-3-a-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton130`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton131`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton132`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton133`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton134`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-1-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton135`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton136`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton137`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton138`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton139`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-a-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton140`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton141`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton142`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton143`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton144`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-2-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton145`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton146`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton147`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton148`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton149`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-3-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton150`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton151`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton152`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton153`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton154`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2-a-a-2-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton155`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton156`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton157`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton158`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton159`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3-a-a-3-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton160`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton161`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton162`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton163`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton164`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `6 blocks`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-a-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton165`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton166`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton167`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton168`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton169`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton170`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1-a-a-a-a-3`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton171`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton172`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton173`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton174`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton175`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton176`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-a-1-a-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton177`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton178`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton179`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton180`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton181`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton182`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-a-2-a-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton183`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton184`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton185`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton186`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton187`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton188`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-1-a-a-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton189`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton190`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton191`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton192`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton193`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton194`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-2-a-a-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton195`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton196`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton197`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton198`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton199`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton200`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-a-3-a-a-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton201`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton202`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton203`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton204`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton205`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton206`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1-a-a-1-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton207`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton208`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton209`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton210`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton211`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton212`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-a-2-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton213`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton214`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton215`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton216`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton217`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton218`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-3-a-a-3-a`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton219`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton220`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton221`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton222`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton223`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton224`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1-a-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton225`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton226`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton227`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton228`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton229`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton230`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-a-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton231`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton232`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton233`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton234`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton235`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton236`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-1-a-1-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton237`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton238`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton239`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton240`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton241`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton242`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-2-a-2-a-2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton243`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton244`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton245`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton246`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton247`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton248`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `a-3-a-2-a-1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton249`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton250`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton251`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton252`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="auto") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton253`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton254`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All default`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1 block`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton255`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton256`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton257`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton258`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton259`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton260`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `4 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton261`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton262`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton263`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton264`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `5 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton265`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton266`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton267`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton268`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton269`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `6 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton270`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton271`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton272`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton273`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton274`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton275`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All 1`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1 block`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton276`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton277`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton278`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton279`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton280`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton281`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `4 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton282`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton283`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton284`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton285`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `5 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton286`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton287`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton288`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton289`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton290`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `6 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton291`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton292`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton293`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton294`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton295`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="1") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton296`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All 2`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1 block`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton297`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton298`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton299`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton300`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton301`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton302`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `4 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton303`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton304`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton305`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton306`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `5 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton307`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton308`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton309`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton310`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton311`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `6 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton312`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton313`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton314`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton315`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton316`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="2") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton317`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All 3`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1 block`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton318`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton319`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton320`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton321`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton322`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton323`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `4 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton324`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton325`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton326`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton327`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `5 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton328`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton329`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton330`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton331`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton332`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `6 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton333`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton334`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton335`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton336`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton337`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="3") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton338`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                    )->end(
                )->end(
                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `All 4`
                    )->a( n = `showTitle`      v = `true`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `1 block`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton339`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `2 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton340`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton341`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `3 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton342`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton343`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton344`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `4 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton345`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton346`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton347`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton348`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `5 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton349`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton350`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton351`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton352`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton353`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                            )->end(
                        )->end(
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `6 blocks`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton354`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton355`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton356`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton357`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton358`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
                                " sample:InfoButton (columnLayout="4") inlined
                                )->tag( n = `Button` ns = `m`
                                    )->a( n = `id`    v = `infoButton359`
                                    )->a( n = `width` v = `100%`
                                    )->a( n = `text`  v = `infoButton`
                                    )->a( n = `type`  v = `Emphasized`
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

      WHEN `TOGGLE_TITLE`.
        " toggleTitle: ConfigModel>/subSectionLayout flips TitleOnTop <-> TitleOnLeft
        subsection_layout = COND #( WHEN subsection_layout = `TitleOnTop` THEN `TitleOnLeft` ELSE `TitleOnTop` ).

      WHEN `TOGGLE_TWO_COLUMNS`.
        " toggleUseTwoColumns: ConfigModel>/useTwoColumnsForLargeScreen flips
        two_columns = xsdbool( two_columns = abap_false ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the ConfigModel the controller seeds in onInit
    subsection_layout = `TitleOnTop`.
    two_columns       = abap_false.

  ENDMETHOD.

ENDCLASS.
