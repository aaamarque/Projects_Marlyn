# This script segment is generated automatically by AutoPilot

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler bnn_dense_layer_ap_int_9_s_p_ZL9golden_w2_0_ROM_AUTO_1R BINDTYPE {storage} TYPE {rom} IMPL {auto} LATENCY 2 ALLOW_PRAGMA 1
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler bnn_dense_layer_ap_int_9_s_p_ZL9golden_w2_1_ROM_AUTO_1R BINDTYPE {storage} TYPE {rom} IMPL {auto} LATENCY 2 ALLOW_PRAGMA 1
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 309 \
    name input_0_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_input_0_val \
    op interface \
    ports { input_0_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 310 \
    name input_1_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_input_1_val \
    op interface \
    ports { input_1_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 311 \
    name input_2_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_input_2_val \
    op interface \
    ports { input_2_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 312 \
    name input_3_val \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_input_3_val \
    op interface \
    ports { input_3_val { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 313 \
    name output_0 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_0 \
    op interface \
    ports { output_0 { O 9 vector } output_0_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 314 \
    name output_1 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_1 \
    op interface \
    ports { output_1 { O 9 vector } output_1_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 315 \
    name output_2 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_2 \
    op interface \
    ports { output_2 { O 9 vector } output_2_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 316 \
    name output_3 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_3 \
    op interface \
    ports { output_3 { O 9 vector } output_3_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 317 \
    name output_4 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_4 \
    op interface \
    ports { output_4 { O 9 vector } output_4_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 318 \
    name output_5 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_5 \
    op interface \
    ports { output_5 { O 9 vector } output_5_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 319 \
    name output_6 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_6 \
    op interface \
    ports { output_6 { O 9 vector } output_6_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 320 \
    name output_7 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_7 \
    op interface \
    ports { output_7 { O 9 vector } output_7_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 321 \
    name output_8 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_8 \
    op interface \
    ports { output_8 { O 9 vector } output_8_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 322 \
    name output_9 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_9 \
    op interface \
    ports { output_9 { O 9 vector } output_9_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 323 \
    name output_10 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_10 \
    op interface \
    ports { output_10 { O 9 vector } output_10_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 324 \
    name output_11 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_11 \
    op interface \
    ports { output_11 { O 9 vector } output_11_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 325 \
    name output_12 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_12 \
    op interface \
    ports { output_12 { O 9 vector } output_12_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 326 \
    name output_13 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_13 \
    op interface \
    ports { output_13 { O 9 vector } output_13_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 327 \
    name output_14 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_14 \
    op interface \
    ports { output_14 { O 9 vector } output_14_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 328 \
    name output_15 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_15 \
    op interface \
    ports { output_15 { O 9 vector } output_15_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 329 \
    name output_16 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_16 \
    op interface \
    ports { output_16 { O 9 vector } output_16_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 330 \
    name output_17 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_17 \
    op interface \
    ports { output_17 { O 9 vector } output_17_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 331 \
    name output_18 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_18 \
    op interface \
    ports { output_18 { O 9 vector } output_18_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 332 \
    name output_19 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_19 \
    op interface \
    ports { output_19 { O 9 vector } output_19_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 333 \
    name output_20 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_20 \
    op interface \
    ports { output_20 { O 9 vector } output_20_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 334 \
    name output_21 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_21 \
    op interface \
    ports { output_21 { O 9 vector } output_21_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 335 \
    name output_22 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_22 \
    op interface \
    ports { output_22 { O 9 vector } output_22_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 336 \
    name output_23 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_23 \
    op interface \
    ports { output_23 { O 9 vector } output_23_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 337 \
    name output_24 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_24 \
    op interface \
    ports { output_24 { O 9 vector } output_24_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 338 \
    name output_25 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_25 \
    op interface \
    ports { output_25 { O 9 vector } output_25_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 339 \
    name output_26 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_26 \
    op interface \
    ports { output_26 { O 9 vector } output_26_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 340 \
    name output_27 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_27 \
    op interface \
    ports { output_27 { O 9 vector } output_27_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 341 \
    name output_28 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_28 \
    op interface \
    ports { output_28 { O 9 vector } output_28_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 342 \
    name output_29 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_29 \
    op interface \
    ports { output_29 { O 9 vector } output_29_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 343 \
    name output_30 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_30 \
    op interface \
    ports { output_30 { O 9 vector } output_30_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 344 \
    name output_31 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_31 \
    op interface \
    ports { output_31 { O 9 vector } output_31_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 345 \
    name output_32 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_32 \
    op interface \
    ports { output_32 { O 9 vector } output_32_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 346 \
    name output_33 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_33 \
    op interface \
    ports { output_33 { O 9 vector } output_33_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 347 \
    name output_34 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_34 \
    op interface \
    ports { output_34 { O 9 vector } output_34_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 348 \
    name output_35 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_35 \
    op interface \
    ports { output_35 { O 9 vector } output_35_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 349 \
    name output_36 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_36 \
    op interface \
    ports { output_36 { O 9 vector } output_36_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 350 \
    name output_37 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_37 \
    op interface \
    ports { output_37 { O 9 vector } output_37_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 351 \
    name output_38 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_38 \
    op interface \
    ports { output_38 { O 9 vector } output_38_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 352 \
    name output_39 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_39 \
    op interface \
    ports { output_39 { O 9 vector } output_39_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 353 \
    name output_40 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_40 \
    op interface \
    ports { output_40 { O 9 vector } output_40_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 354 \
    name output_41 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_41 \
    op interface \
    ports { output_41 { O 9 vector } output_41_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 355 \
    name output_42 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_42 \
    op interface \
    ports { output_42 { O 9 vector } output_42_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 356 \
    name output_43 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_43 \
    op interface \
    ports { output_43 { O 9 vector } output_43_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 357 \
    name output_44 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_44 \
    op interface \
    ports { output_44 { O 9 vector } output_44_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 358 \
    name output_45 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_45 \
    op interface \
    ports { output_45 { O 9 vector } output_45_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 359 \
    name output_46 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_46 \
    op interface \
    ports { output_46 { O 9 vector } output_46_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 360 \
    name output_47 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_47 \
    op interface \
    ports { output_47 { O 9 vector } output_47_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 361 \
    name output_48 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_48 \
    op interface \
    ports { output_48 { O 9 vector } output_48_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 362 \
    name output_49 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_49 \
    op interface \
    ports { output_49 { O 9 vector } output_49_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 363 \
    name output_50 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_50 \
    op interface \
    ports { output_50 { O 9 vector } output_50_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 364 \
    name output_51 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_51 \
    op interface \
    ports { output_51 { O 9 vector } output_51_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 365 \
    name output_52 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_52 \
    op interface \
    ports { output_52 { O 9 vector } output_52_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 366 \
    name output_53 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_53 \
    op interface \
    ports { output_53 { O 9 vector } output_53_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 367 \
    name output_54 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_54 \
    op interface \
    ports { output_54 { O 9 vector } output_54_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 368 \
    name output_55 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_55 \
    op interface \
    ports { output_55 { O 9 vector } output_55_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 369 \
    name output_56 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_56 \
    op interface \
    ports { output_56 { O 9 vector } output_56_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 370 \
    name output_57 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_57 \
    op interface \
    ports { output_57 { O 9 vector } output_57_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 371 \
    name output_58 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_58 \
    op interface \
    ports { output_58 { O 9 vector } output_58_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 372 \
    name output_59 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_59 \
    op interface \
    ports { output_59 { O 9 vector } output_59_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 373 \
    name output_60 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_60 \
    op interface \
    ports { output_60 { O 9 vector } output_60_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 374 \
    name output_61 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_61 \
    op interface \
    ports { output_61 { O 9 vector } output_61_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 375 \
    name output_62 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_62 \
    op interface \
    ports { output_62 { O 9 vector } output_62_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 376 \
    name output_63 \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_63 \
    op interface \
    ports { output_63 { O 9 vector } output_63_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


# flow_control definition:
set InstName bnn_flow_control_loop_pipe_sequential_init_U
set CompName bnn_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix bnn_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


