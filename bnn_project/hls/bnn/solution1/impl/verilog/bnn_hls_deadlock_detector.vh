
    wire dl_reset;
    wire dl_clock;
    assign dl_reset = ap_rst_n;
    assign dl_clock = ap_clk;
    wire [1:0] proc_0_data_FIFO_blk;
    wire [1:0] proc_0_data_PIPO_blk;
    wire [1:0] proc_0_start_FIFO_blk;
    wire [1:0] proc_0_TLF_FIFO_blk;
    wire [1:0] proc_0_input_sync_blk;
    wire [1:0] proc_0_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_0;
    reg [1:0] proc_dep_vld_vec_0_reg;
    wire [1:0] in_chan_dep_vld_vec_0;
    wire [15:0] in_chan_dep_data_vec_0;
    wire [1:0] token_in_vec_0;
    wire [1:0] out_chan_dep_vld_vec_0;
    wire [7:0] out_chan_dep_data_0;
    wire [1:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [7:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_7_0;
    wire [7:0] dep_chan_data_7_0;
    wire token_7_0;
    wire [0:0] proc_1_data_FIFO_blk;
    wire [0:0] proc_1_data_PIPO_blk;
    wire [0:0] proc_1_start_FIFO_blk;
    wire [0:0] proc_1_TLF_FIFO_blk;
    wire [0:0] proc_1_input_sync_blk;
    wire [0:0] proc_1_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_1;
    reg [0:0] proc_dep_vld_vec_1_reg;
    wire [1:0] in_chan_dep_vld_vec_1;
    wire [15:0] in_chan_dep_data_vec_1;
    wire [1:0] token_in_vec_1;
    wire [0:0] out_chan_dep_vld_vec_1;
    wire [7:0] out_chan_dep_data_1;
    wire [0:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [7:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_2_1;
    wire [7:0] dep_chan_data_2_1;
    wire token_2_1;
    wire [0:0] proc_2_data_FIFO_blk;
    wire [0:0] proc_2_data_PIPO_blk;
    wire [0:0] proc_2_start_FIFO_blk;
    wire [0:0] proc_2_TLF_FIFO_blk;
    wire [0:0] proc_2_input_sync_blk;
    wire [0:0] proc_2_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_2;
    reg [0:0] proc_dep_vld_vec_2_reg;
    wire [0:0] in_chan_dep_vld_vec_2;
    wire [7:0] in_chan_dep_data_vec_2;
    wire [0:0] token_in_vec_2;
    wire [0:0] out_chan_dep_vld_vec_2;
    wire [7:0] out_chan_dep_data_2;
    wire [0:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_3_2;
    wire [7:0] dep_chan_data_3_2;
    wire token_3_2;
    wire [0:0] proc_3_data_FIFO_blk;
    wire [0:0] proc_3_data_PIPO_blk;
    wire [0:0] proc_3_start_FIFO_blk;
    wire [0:0] proc_3_TLF_FIFO_blk;
    wire [0:0] proc_3_input_sync_blk;
    wire [0:0] proc_3_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_3;
    reg [0:0] proc_dep_vld_vec_3_reg;
    wire [0:0] in_chan_dep_vld_vec_3;
    wire [7:0] in_chan_dep_data_vec_3;
    wire [0:0] token_in_vec_3;
    wire [0:0] out_chan_dep_vld_vec_3;
    wire [7:0] out_chan_dep_data_3;
    wire [0:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_4_3;
    wire [7:0] dep_chan_data_4_3;
    wire token_4_3;
    wire [0:0] proc_4_data_FIFO_blk;
    wire [0:0] proc_4_data_PIPO_blk;
    wire [0:0] proc_4_start_FIFO_blk;
    wire [0:0] proc_4_TLF_FIFO_blk;
    wire [0:0] proc_4_input_sync_blk;
    wire [0:0] proc_4_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_4;
    reg [0:0] proc_dep_vld_vec_4_reg;
    wire [0:0] in_chan_dep_vld_vec_4;
    wire [7:0] in_chan_dep_data_vec_4;
    wire [0:0] token_in_vec_4;
    wire [0:0] out_chan_dep_vld_vec_4;
    wire [7:0] out_chan_dep_data_4;
    wire [0:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_5_4;
    wire [7:0] dep_chan_data_5_4;
    wire token_5_4;
    wire [0:0] proc_5_data_FIFO_blk;
    wire [0:0] proc_5_data_PIPO_blk;
    wire [0:0] proc_5_start_FIFO_blk;
    wire [0:0] proc_5_TLF_FIFO_blk;
    wire [0:0] proc_5_input_sync_blk;
    wire [0:0] proc_5_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_5;
    reg [0:0] proc_dep_vld_vec_5_reg;
    wire [0:0] in_chan_dep_vld_vec_5;
    wire [7:0] in_chan_dep_data_vec_5;
    wire [0:0] token_in_vec_5;
    wire [0:0] out_chan_dep_vld_vec_5;
    wire [7:0] out_chan_dep_data_5;
    wire [0:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_6_5;
    wire [7:0] dep_chan_data_6_5;
    wire token_6_5;
    wire [0:0] proc_6_data_FIFO_blk;
    wire [0:0] proc_6_data_PIPO_blk;
    wire [0:0] proc_6_start_FIFO_blk;
    wire [0:0] proc_6_TLF_FIFO_blk;
    wire [0:0] proc_6_input_sync_blk;
    wire [0:0] proc_6_output_sync_blk;
    wire [0:0] proc_dep_vld_vec_6;
    reg [0:0] proc_dep_vld_vec_6_reg;
    wire [0:0] in_chan_dep_vld_vec_6;
    wire [7:0] in_chan_dep_data_vec_6;
    wire [0:0] token_in_vec_6;
    wire [0:0] out_chan_dep_vld_vec_6;
    wire [7:0] out_chan_dep_data_6;
    wire [0:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_7_6;
    wire [7:0] dep_chan_data_7_6;
    wire token_7_6;
    wire [1:0] proc_7_data_FIFO_blk;
    wire [1:0] proc_7_data_PIPO_blk;
    wire [1:0] proc_7_start_FIFO_blk;
    wire [1:0] proc_7_TLF_FIFO_blk;
    wire [1:0] proc_7_input_sync_blk;
    wire [1:0] proc_7_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_7;
    reg [1:0] proc_dep_vld_vec_7_reg;
    wire [0:0] in_chan_dep_vld_vec_7;
    wire [7:0] in_chan_dep_data_vec_7;
    wire [0:0] token_in_vec_7;
    wire [1:0] out_chan_dep_vld_vec_7;
    wire [7:0] out_chan_dep_data_7;
    wire [1:0] token_out_vec_7;
    wire dl_detect_out_7;
    wire dep_chan_vld_0_7;
    wire [7:0] dep_chan_data_0_7;
    wire token_0_7;
    wire [7:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [7:0] origin;

    reg ap_done_reg_0;// for module dense_layer_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= dense_layer_U0.ap_done & ~dense_layer_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module sign_and_quantize_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= sign_and_quantize_U0.ap_done & ~sign_and_quantize_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module dense_layer_1_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= dense_layer_1_U0.ap_done & ~dense_layer_1_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module sign_and_quantize_2_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= sign_and_quantize_2_U0.ap_done & ~sign_and_quantize_2_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module dense_layer_3_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= dense_layer_3_U0.ap_done & ~dense_layer_3_U0.ap_continue;
        end
    end

    reg ap_done_reg_5;// for module Block_entry_gmem_wr_proc_U0
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            ap_done_reg_5 <= 'b0;
        end
        else begin
            ap_done_reg_5 <= Block_entry_gmem_wr_proc_U0.ap_done & ~Block_entry_gmem_wr_proc_U0.ap_continue;
        end
    end

    // Process: entry_proc_U0
    bnn_hls_deadlock_detect_unit #(8, 0, 2, 2) bnn_hls_deadlock_detect_unit_0 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~entry_proc_U0.ys_c_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0;
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0;
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0;
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0 | (ap_sync_entry_proc_U0_ap_ready & entry_proc_U0.ap_idle & ~ap_sync_Block_entry_gmem_rd_proc_U0_ap_ready);
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[7 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_7_0;
    assign in_chan_dep_data_vec_0[15 : 8] = dep_chan_data_7_0;
    assign token_in_vec_0[1] = token_7_0;
    assign dep_chan_vld_0_7 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_7 = out_chan_dep_data_0;
    assign token_0_7 = token_out_vec_0[0];
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[1];

    // Process: Block_entry_gmem_rd_proc_U0
    bnn_hls_deadlock_detect_unit #(8, 1, 2, 1) bnn_hls_deadlock_detect_unit_1 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0;
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0 | (ap_sync_Block_entry_gmem_rd_proc_U0_ap_ready & Block_entry_gmem_rd_proc_U0.ap_idle & ~ap_sync_entry_proc_U0_ap_ready);
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[7 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_2_1;
    assign in_chan_dep_data_vec_1[15 : 8] = dep_chan_data_2_1;
    assign token_in_vec_1[1] = token_2_1;
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[0];

    // Process: dense_layer_U0
    bnn_hls_deadlock_detect_unit #(8, 2, 1, 1) bnn_hls_deadlock_detect_unit_2 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0;
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0 | (~p_loc_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc_channel_U.if_write) | (~p_loc2_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc2_channel_U.if_write) | (~p_loc3_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc3_channel_U.if_write) | (~p_loc4_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc4_channel_U.if_write) | (~p_loc5_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc5_channel_U.if_write) | (~p_loc6_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc6_channel_U.if_write) | (~p_loc7_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc7_channel_U.if_write) | (~p_loc8_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc8_channel_U.if_write) | (~p_loc9_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc9_channel_U.if_write) | (~p_loc10_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc10_channel_U.if_write) | (~p_loc11_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc11_channel_U.if_write) | (~p_loc12_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc12_channel_U.if_write) | (~p_loc13_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc13_channel_U.if_write) | (~p_loc14_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc14_channel_U.if_write) | (~p_loc15_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc15_channel_U.if_write) | (~p_loc16_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc16_channel_U.if_write) | (~p_loc17_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc17_channel_U.if_write) | (~p_loc18_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc18_channel_U.if_write) | (~p_loc19_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc19_channel_U.if_write) | (~p_loc20_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc20_channel_U.if_write) | (~p_loc21_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc21_channel_U.if_write) | (~p_loc22_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc22_channel_U.if_write) | (~p_loc23_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc23_channel_U.if_write) | (~p_loc24_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc24_channel_U.if_write) | (~p_loc25_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc25_channel_U.if_write);
    assign proc_2_input_sync_blk[0] = 1'b0;
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_3_2;
    assign in_chan_dep_data_vec_2[7 : 0] = dep_chan_data_3_2;
    assign token_in_vec_2[0] = token_3_2;
    assign dep_chan_vld_2_1 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_1 = out_chan_dep_data_2;
    assign token_2_1 = token_out_vec_2[0];

    // Process: sign_and_quantize_U0
    bnn_hls_deadlock_detect_unit #(8, 3, 1, 1) bnn_hls_deadlock_detect_unit_3 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0;
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0 | (~layer1_output_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_U.if_write) | (~layer1_output_1_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_1_U.if_write) | (~layer1_output_2_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_2_U.if_write) | (~layer1_output_3_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_3_U.if_write) | (~layer1_output_4_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_4_U.if_write) | (~layer1_output_5_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_5_U.if_write) | (~layer1_output_6_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_6_U.if_write) | (~layer1_output_7_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_7_U.if_write) | (~layer1_output_8_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_8_U.if_write) | (~layer1_output_9_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_9_U.if_write) | (~layer1_output_10_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_10_U.if_write) | (~layer1_output_11_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_11_U.if_write) | (~layer1_output_12_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_12_U.if_write) | (~layer1_output_13_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_13_U.if_write) | (~layer1_output_14_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_14_U.if_write) | (~layer1_output_15_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_15_U.if_write) | (~layer1_output_16_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_16_U.if_write) | (~layer1_output_17_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_17_U.if_write) | (~layer1_output_18_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_18_U.if_write) | (~layer1_output_19_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_19_U.if_write) | (~layer1_output_20_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_20_U.if_write) | (~layer1_output_21_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_21_U.if_write) | (~layer1_output_22_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_22_U.if_write) | (~layer1_output_23_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_23_U.if_write) | (~layer1_output_24_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_24_U.if_write) | (~layer1_output_25_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_25_U.if_write) | (~layer1_output_26_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_26_U.if_write) | (~layer1_output_27_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_27_U.if_write) | (~layer1_output_28_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_28_U.if_write) | (~layer1_output_29_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_29_U.if_write) | (~layer1_output_30_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_30_U.if_write) | (~layer1_output_31_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_31_U.if_write) | (~layer1_output_32_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_32_U.if_write) | (~layer1_output_33_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_33_U.if_write) | (~layer1_output_34_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_34_U.if_write) | (~layer1_output_35_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_35_U.if_write) | (~layer1_output_36_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_36_U.if_write) | (~layer1_output_37_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_37_U.if_write) | (~layer1_output_38_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_38_U.if_write) | (~layer1_output_39_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_39_U.if_write) | (~layer1_output_40_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_40_U.if_write) | (~layer1_output_41_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_41_U.if_write) | (~layer1_output_42_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_42_U.if_write) | (~layer1_output_43_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_43_U.if_write) | (~layer1_output_44_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_44_U.if_write) | (~layer1_output_45_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_45_U.if_write) | (~layer1_output_46_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_46_U.if_write) | (~layer1_output_47_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_47_U.if_write) | (~layer1_output_48_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_48_U.if_write) | (~layer1_output_49_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_49_U.if_write) | (~layer1_output_50_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_50_U.if_write) | (~layer1_output_51_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_51_U.if_write) | (~layer1_output_52_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_52_U.if_write) | (~layer1_output_53_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_53_U.if_write) | (~layer1_output_54_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_54_U.if_write) | (~layer1_output_55_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_55_U.if_write) | (~layer1_output_56_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_56_U.if_write) | (~layer1_output_57_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_57_U.if_write) | (~layer1_output_58_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_58_U.if_write) | (~layer1_output_59_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_59_U.if_write) | (~layer1_output_60_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_60_U.if_write) | (~layer1_output_61_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_61_U.if_write) | (~layer1_output_62_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_62_U.if_write) | (~layer1_output_63_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_63_U.if_write) | (~layer1_output_64_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_64_U.if_write) | (~layer1_output_65_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_65_U.if_write) | (~layer1_output_66_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_66_U.if_write) | (~layer1_output_67_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_67_U.if_write) | (~layer1_output_68_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_68_U.if_write) | (~layer1_output_69_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_69_U.if_write) | (~layer1_output_70_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_70_U.if_write) | (~layer1_output_71_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_71_U.if_write) | (~layer1_output_72_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_72_U.if_write) | (~layer1_output_73_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_73_U.if_write) | (~layer1_output_74_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_74_U.if_write) | (~layer1_output_75_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_75_U.if_write) | (~layer1_output_76_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_76_U.if_write) | (~layer1_output_77_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_77_U.if_write) | (~layer1_output_78_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_78_U.if_write) | (~layer1_output_79_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_79_U.if_write) | (~layer1_output_80_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_80_U.if_write) | (~layer1_output_81_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_81_U.if_write) | (~layer1_output_82_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_82_U.if_write) | (~layer1_output_83_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_83_U.if_write) | (~layer1_output_84_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_84_U.if_write) | (~layer1_output_85_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_85_U.if_write) | (~layer1_output_86_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_86_U.if_write) | (~layer1_output_87_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_87_U.if_write) | (~layer1_output_88_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_88_U.if_write) | (~layer1_output_89_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_89_U.if_write) | (~layer1_output_90_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_90_U.if_write) | (~layer1_output_91_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_91_U.if_write) | (~layer1_output_92_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_92_U.if_write) | (~layer1_output_93_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_93_U.if_write) | (~layer1_output_94_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_94_U.if_write) | (~layer1_output_95_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_95_U.if_write) | (~layer1_output_96_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_96_U.if_write) | (~layer1_output_97_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_97_U.if_write) | (~layer1_output_98_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_98_U.if_write) | (~layer1_output_99_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_99_U.if_write) | (~layer1_output_100_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_100_U.if_write) | (~layer1_output_101_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_101_U.if_write) | (~layer1_output_102_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_102_U.if_write) | (~layer1_output_103_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_103_U.if_write) | (~layer1_output_104_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_104_U.if_write) | (~layer1_output_105_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_105_U.if_write) | (~layer1_output_106_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_106_U.if_write) | (~layer1_output_107_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_107_U.if_write) | (~layer1_output_108_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_108_U.if_write) | (~layer1_output_109_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_109_U.if_write) | (~layer1_output_110_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_110_U.if_write) | (~layer1_output_111_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_111_U.if_write) | (~layer1_output_112_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_112_U.if_write) | (~layer1_output_113_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_113_U.if_write) | (~layer1_output_114_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_114_U.if_write) | (~layer1_output_115_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_115_U.if_write) | (~layer1_output_116_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_116_U.if_write) | (~layer1_output_117_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_117_U.if_write) | (~layer1_output_118_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_118_U.if_write) | (~layer1_output_119_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_119_U.if_write) | (~layer1_output_120_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_120_U.if_write) | (~layer1_output_121_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_121_U.if_write) | (~layer1_output_122_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_122_U.if_write) | (~layer1_output_123_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_123_U.if_write) | (~layer1_output_124_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_124_U.if_write) | (~layer1_output_125_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_125_U.if_write) | (~layer1_output_126_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_126_U.if_write) | (~layer1_output_127_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_127_U.if_write);
    assign proc_3_input_sync_blk[0] = 1'b0;
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[7 : 0] = dep_chan_data_4_3;
    assign token_in_vec_3[0] = token_4_3;
    assign dep_chan_vld_3_2 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_2 = out_chan_dep_data_3;
    assign token_3_2 = token_out_vec_3[0];

    // Process: dense_layer_1_U0
    bnn_hls_deadlock_detect_unit #(8, 4, 1, 1) bnn_hls_deadlock_detect_unit_4 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0;
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0;
    assign proc_4_TLF_FIFO_blk[0] = 1'b0 | (~layer1_quantized_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_U.if_write) | (~layer1_quantized_1_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_1_U.if_write) | (~layer1_quantized_2_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_2_U.if_write) | (~layer1_quantized_3_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_3_U.if_write);
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_5_4;
    assign in_chan_dep_data_vec_4[7 : 0] = dep_chan_data_5_4;
    assign token_in_vec_4[0] = token_5_4;
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[0];

    // Process: sign_and_quantize_2_U0
    bnn_hls_deadlock_detect_unit #(8, 5, 1, 1) bnn_hls_deadlock_detect_unit_5 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0;
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0;
    assign proc_5_TLF_FIFO_blk[0] = 1'b0 | (~layer2_output_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_U.if_write) | (~layer2_output_1_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_1_U.if_write) | (~layer2_output_2_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_2_U.if_write) | (~layer2_output_3_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_3_U.if_write) | (~layer2_output_4_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_4_U.if_write) | (~layer2_output_5_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_5_U.if_write) | (~layer2_output_6_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_6_U.if_write) | (~layer2_output_7_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_7_U.if_write) | (~layer2_output_8_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_8_U.if_write) | (~layer2_output_9_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_9_U.if_write) | (~layer2_output_10_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_10_U.if_write) | (~layer2_output_11_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_11_U.if_write) | (~layer2_output_12_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_12_U.if_write) | (~layer2_output_13_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_13_U.if_write) | (~layer2_output_14_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_14_U.if_write) | (~layer2_output_15_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_15_U.if_write) | (~layer2_output_16_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_16_U.if_write) | (~layer2_output_17_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_17_U.if_write) | (~layer2_output_18_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_18_U.if_write) | (~layer2_output_19_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_19_U.if_write) | (~layer2_output_20_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_20_U.if_write) | (~layer2_output_21_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_21_U.if_write) | (~layer2_output_22_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_22_U.if_write) | (~layer2_output_23_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_23_U.if_write) | (~layer2_output_24_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_24_U.if_write) | (~layer2_output_25_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_25_U.if_write) | (~layer2_output_26_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_26_U.if_write) | (~layer2_output_27_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_27_U.if_write) | (~layer2_output_28_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_28_U.if_write) | (~layer2_output_29_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_29_U.if_write) | (~layer2_output_30_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_30_U.if_write) | (~layer2_output_31_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_31_U.if_write) | (~layer2_output_32_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_32_U.if_write) | (~layer2_output_33_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_33_U.if_write) | (~layer2_output_34_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_34_U.if_write) | (~layer2_output_35_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_35_U.if_write) | (~layer2_output_36_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_36_U.if_write) | (~layer2_output_37_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_37_U.if_write) | (~layer2_output_38_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_38_U.if_write) | (~layer2_output_39_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_39_U.if_write) | (~layer2_output_40_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_40_U.if_write) | (~layer2_output_41_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_41_U.if_write) | (~layer2_output_42_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_42_U.if_write) | (~layer2_output_43_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_43_U.if_write) | (~layer2_output_44_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_44_U.if_write) | (~layer2_output_45_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_45_U.if_write) | (~layer2_output_46_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_46_U.if_write) | (~layer2_output_47_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_47_U.if_write) | (~layer2_output_48_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_48_U.if_write) | (~layer2_output_49_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_49_U.if_write) | (~layer2_output_50_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_50_U.if_write) | (~layer2_output_51_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_51_U.if_write) | (~layer2_output_52_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_52_U.if_write) | (~layer2_output_53_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_53_U.if_write) | (~layer2_output_54_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_54_U.if_write) | (~layer2_output_55_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_55_U.if_write) | (~layer2_output_56_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_56_U.if_write) | (~layer2_output_57_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_57_U.if_write) | (~layer2_output_58_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_58_U.if_write) | (~layer2_output_59_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_59_U.if_write) | (~layer2_output_60_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_60_U.if_write) | (~layer2_output_61_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_61_U.if_write) | (~layer2_output_62_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_62_U.if_write) | (~layer2_output_63_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_63_U.if_write);
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_6_5;
    assign in_chan_dep_data_vec_5[7 : 0] = dep_chan_data_6_5;
    assign token_in_vec_5[0] = token_6_5;
    assign dep_chan_vld_5_4 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_4 = out_chan_dep_data_5;
    assign token_5_4 = token_out_vec_5[0];

    // Process: dense_layer_3_U0
    bnn_hls_deadlock_detect_unit #(8, 6, 1, 1) bnn_hls_deadlock_detect_unit_6 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0;
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0;
    assign proc_6_TLF_FIFO_blk[0] = 1'b0 | (~layer2_quantized_U.if_empty_n & dense_layer_3_U0.ap_idle & ~layer2_quantized_U.if_write) | (~layer2_quantized_1_U.if_empty_n & dense_layer_3_U0.ap_idle & ~layer2_quantized_1_U.if_write);
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_7_6;
    assign in_chan_dep_data_vec_6[7 : 0] = dep_chan_data_7_6;
    assign token_in_vec_6[0] = token_7_6;
    assign dep_chan_vld_6_5 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_5 = out_chan_dep_data_6;
    assign token_6_5 = token_out_vec_6[0];

    // Process: Block_entry_gmem_wr_proc_U0
    bnn_hls_deadlock_detect_unit #(8, 7, 1, 2) bnn_hls_deadlock_detect_unit_7 (
        .reset(dl_reset),
        .clock(dl_clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_7),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_7),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_7),
        .token_in_vec(token_in_vec_7),
        .dl_detect_in(dl_detect_out),
        .origin(origin[7]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_7),
        .out_chan_dep_data(out_chan_dep_data_7),
        .token_out_vec(token_out_vec_7),
        .dl_detect_out(dl_in_vec[7]));

    assign proc_7_data_FIFO_blk[0] = 1'b0 | (~Block_entry_gmem_wr_proc_U0.ys_blk_n);
    assign proc_7_data_PIPO_blk[0] = 1'b0;
    assign proc_7_start_FIFO_blk[0] = 1'b0;
    assign proc_7_TLF_FIFO_blk[0] = 1'b0;
    assign proc_7_input_sync_blk[0] = 1'b0;
    assign proc_7_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_7[0] = dl_detect_out ? proc_dep_vld_vec_7_reg[0] : (proc_7_data_FIFO_blk[0] | proc_7_data_PIPO_blk[0] | proc_7_start_FIFO_blk[0] | proc_7_TLF_FIFO_blk[0] | proc_7_input_sync_blk[0] | proc_7_output_sync_blk[0]);
    assign proc_7_data_FIFO_blk[1] = 1'b0;
    assign proc_7_data_PIPO_blk[1] = 1'b0;
    assign proc_7_start_FIFO_blk[1] = 1'b0;
    assign proc_7_TLF_FIFO_blk[1] = 1'b0 | (~layer3_output_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_U.if_write) | (~layer3_output_1_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_1_U.if_write) | (~layer3_output_2_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_2_U.if_write) | (~layer3_output_3_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_3_U.if_write) | (~layer3_output_4_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_4_U.if_write) | (~layer3_output_5_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_5_U.if_write) | (~layer3_output_6_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_6_U.if_write) | (~layer3_output_7_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_7_U.if_write) | (~layer3_output_8_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_8_U.if_write) | (~layer3_output_9_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_9_U.if_write);
    assign proc_7_input_sync_blk[1] = 1'b0;
    assign proc_7_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_7[1] = dl_detect_out ? proc_dep_vld_vec_7_reg[1] : (proc_7_data_FIFO_blk[1] | proc_7_data_PIPO_blk[1] | proc_7_start_FIFO_blk[1] | proc_7_TLF_FIFO_blk[1] | proc_7_input_sync_blk[1] | proc_7_output_sync_blk[1]);
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            proc_dep_vld_vec_7_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_7_reg <= proc_dep_vld_vec_7;
        end
    end
    assign in_chan_dep_vld_vec_7[0] = dep_chan_vld_0_7;
    assign in_chan_dep_data_vec_7[7 : 0] = dep_chan_data_0_7;
    assign token_in_vec_7[0] = token_0_7;
    assign dep_chan_vld_7_0 = out_chan_dep_vld_vec_7[0];
    assign dep_chan_data_7_0 = out_chan_dep_data_7;
    assign token_7_0 = token_out_vec_7[0];
    assign dep_chan_vld_7_6 = out_chan_dep_vld_vec_7[1];
    assign dep_chan_data_7_6 = out_chan_dep_data_7;
    assign token_7_6 = token_out_vec_7[1];


`include "bnn_hls_deadlock_report_unit.vh"
