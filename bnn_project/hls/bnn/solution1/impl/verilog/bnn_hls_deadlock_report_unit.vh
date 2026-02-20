   
    parameter PROC_NUM = 8;
    parameter ST_IDLE = 3'b000;
    parameter ST_FILTER_FAKE = 3'b001;
    parameter ST_DL_DETECTED = 3'b010;
    parameter ST_DL_REPORT = 3'b100;
   

    reg [2:0] CS_fsm;
    reg [2:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    reg [31:0] dl_keep_cnt;
    reg stop_report_path;
    reg [PROC_NUM - 1:0] reported_proc;
    integer i;
    integer fp;

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            reported_proc <= 'b0;
        end
        else if (CS_fsm == ST_DL_REPORT) begin
            reported_proc <= reported_proc | dl_in_vec;
        end
        else if (CS_fsm == ST_DL_DETECTED) begin
            reported_proc <= 'b0;
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            stop_report_path <= 1'b0;
        end
        else if (CS_fsm == ST_DL_REPORT && (|(dl_in_vec & reported_proc))) begin
            stop_report_path <= 1'b1;
        end
        else if (CS_fsm == ST_IDLE) begin
            stop_report_path <= 1'b0;
        end
    end

    // FSM State machine
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end

    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg or dl_keep_cnt) begin
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_FILTER_FAKE;
                end
                else begin
                    NS_fsm = ST_IDLE;
                end
            end
            ST_FILTER_FAKE: begin
                if (dl_keep_cnt >= 32'd1000) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else if (dl_detect_reg != (dl_detect_reg & dl_in_vec)) begin
                    NS_fsm = ST_IDLE;
                end
                else begin
                    NS_fsm = ST_FILTER_FAKE;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if ((dl_detect_reg != dl_done_reg) && stop_report_path == 1'b0) begin
                    NS_fsm = ST_DL_REPORT;
                end
                else begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                // avoid report deadlock ring.
                else if (|(dl_in_vec & reported_proc)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            default: NS_fsm = ST_IDLE;
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_keep_cnt <= 32'h0;
        end
        else begin
            if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg == (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= dl_keep_cnt + 32'h1;
            end
            else if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg != (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= 32'h0;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = (|dl_detect_reg) && (CS_fsm == ST_DL_DETECTED || CS_fsm == ST_DL_REPORT);

    // dl_done_reg record the cycles has been reported
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    wire [PROC_NUM*PROC_NUM - 1:0] origin_tmp;
    assign origin_tmp[PROC_NUM - 1:0] = (dl_detect_reg[0] & ~dl_done_reg[0]) ? 'b1 : 'b0;
    genvar j;
    generate
    for(j = 1;j < PROC_NUM;j = j + 1) begin: F1
        assign origin_tmp[j*PROC_NUM +: PROC_NUM] = (dl_detect_reg[j] & ~dl_done_reg[j]) ? ('b1 << j) : origin_tmp[(j - 1)*PROC_NUM +: PROC_NUM];
    end
    endgenerate
    always @ (CS_fsm or origin_tmp) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            origin = origin_tmp[(PROC_NUM - 1)*PROC_NUM +: PROC_NUM];
        end
        else begin
            origin = 'b0;
        end
    end

    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // find_df_deadlock to report the deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            find_df_deadlock <= 1'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED && ((dl_detect_reg == dl_done_reg) || (stop_report_path == 1'b1))) begin
                find_df_deadlock <= 1'b1;
            end
            else if (CS_fsm == ST_IDLE) begin
                find_df_deadlock <= 1'b0;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [320:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "bnn_bnn.entry_proc_U0";
                end
                1 : begin
                    proc_path = "bnn_bnn.Block_entry_gmem_rd_proc_U0";
                end
                2 : begin
                    proc_path = "bnn_bnn.dense_layer_U0";
                end
                3 : begin
                    proc_path = "bnn_bnn.sign_and_quantize_U0";
                end
                4 : begin
                    proc_path = "bnn_bnn.dense_layer_1_U0";
                end
                5 : begin
                    proc_path = "bnn_bnn.sign_and_quantize_2_U0";
                end
                6 : begin
                    proc_path = "bnn_bnn.dense_layer_3_U0";
                end
                7 : begin
                    proc_path = "bnn_bnn.Block_entry_gmem_wr_proc_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [320:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", record_time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [320:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [264:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin // for proc 'bnn_bnn.entry_proc_U0'
                    case(index2)
                    7: begin //  for dep proc 'bnn_bnn.Block_entry_gmem_wr_proc_U0'
// for dep channel 'bnn_bnn.ys_c_U' info is :
// blk sig is {~bnn_bnn_inst.entry_proc_U0.ys_c_blk_n data_FIFO}
                        if ((~entry_proc_U0.ys_c_blk_n)) begin
                            if (~ys_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.ys_c_U' written by process 'bnn_bnn.Block_entry_gmem_wr_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.ys_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~ys_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.ys_c_U' read by process 'bnn_bnn.Block_entry_gmem_wr_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.ys_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin //  for dep proc 'bnn_bnn.Block_entry_gmem_rd_proc_U0'
// for dep channel '' info is :
// blk sig is {{bnn_bnn_inst.ap_sync_entry_proc_U0_ap_ready & bnn_bnn_inst.entry_proc_U0.ap_idle & ~bnn_bnn_inst.ap_sync_Block_entry_gmem_rd_proc_U0_ap_ready} input_sync}
                        if ((ap_sync_entry_proc_U0_ap_ready & entry_proc_U0.ap_idle & ~ap_sync_Block_entry_gmem_rd_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                        end
                    end
                    endcase
                end
                1 : begin // for proc 'bnn_bnn.Block_entry_gmem_rd_proc_U0'
                    case(index2)
                    0: begin //  for dep proc 'bnn_bnn.entry_proc_U0'
// for dep channel '' info is :
// blk sig is {{bnn_bnn_inst.ap_sync_Block_entry_gmem_rd_proc_U0_ap_ready & bnn_bnn_inst.Block_entry_gmem_rd_proc_U0.ap_idle & ~bnn_bnn_inst.ap_sync_entry_proc_U0_ap_ready} input_sync}
                        if ((ap_sync_Block_entry_gmem_rd_proc_U0_ap_ready & Block_entry_gmem_rd_proc_U0.ap_idle & ~ap_sync_entry_proc_U0_ap_ready)) begin
                            $display("//      Blocked by input sync logic with process : 'bnn_bnn.entry_proc_U0'");
                        end
                    end
                    endcase
                end
                2 : begin // for proc 'bnn_bnn.dense_layer_U0'
                    case(index2)
                    1: begin //  for dep proc 'bnn_bnn.Block_entry_gmem_rd_proc_U0'
// for dep channel 'bnn_bnn.p_loc_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc_channel_U.if_write)) begin
                            if (~p_loc_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc2_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc2_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc2_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc2_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc2_channel_U.if_write)) begin
                            if (~p_loc2_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc2_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc2_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc2_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc2_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc2_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc3_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc3_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc3_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc3_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc3_channel_U.if_write)) begin
                            if (~p_loc3_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc3_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc3_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc3_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc3_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc3_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc4_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc4_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc4_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc4_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc4_channel_U.if_write)) begin
                            if (~p_loc4_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc4_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc4_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc4_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc4_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc4_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc5_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc5_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc5_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc5_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc5_channel_U.if_write)) begin
                            if (~p_loc5_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc5_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc5_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc5_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc5_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc5_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc6_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc6_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc6_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc6_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc6_channel_U.if_write)) begin
                            if (~p_loc6_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc6_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc6_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc6_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc6_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc6_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc7_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc7_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc7_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc7_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc7_channel_U.if_write)) begin
                            if (~p_loc7_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc7_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc7_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc7_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc7_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc7_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc8_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc8_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc8_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc8_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc8_channel_U.if_write)) begin
                            if (~p_loc8_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc8_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc8_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc8_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc8_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc8_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc9_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc9_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc9_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc9_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc9_channel_U.if_write)) begin
                            if (~p_loc9_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc9_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc9_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc9_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc9_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc9_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc10_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc10_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc10_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc10_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc10_channel_U.if_write)) begin
                            if (~p_loc10_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc10_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc10_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc10_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc10_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc10_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc11_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc11_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc11_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc11_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc11_channel_U.if_write)) begin
                            if (~p_loc11_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc11_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc11_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc11_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc11_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc11_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc12_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc12_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc12_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc12_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc12_channel_U.if_write)) begin
                            if (~p_loc12_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc12_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc12_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc12_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc12_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc12_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc13_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc13_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc13_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc13_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc13_channel_U.if_write)) begin
                            if (~p_loc13_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc13_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc13_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc13_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc13_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc13_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc14_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc14_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc14_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc14_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc14_channel_U.if_write)) begin
                            if (~p_loc14_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc14_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc14_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc14_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc14_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc14_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc15_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc15_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc15_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc15_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc15_channel_U.if_write)) begin
                            if (~p_loc15_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc15_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc15_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc15_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc15_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc15_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc16_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc16_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc16_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc16_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc16_channel_U.if_write)) begin
                            if (~p_loc16_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc16_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc16_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc16_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc16_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc16_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc17_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc17_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc17_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc17_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc17_channel_U.if_write)) begin
                            if (~p_loc17_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc17_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc17_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc17_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc17_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc17_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc18_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc18_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc18_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc18_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc18_channel_U.if_write)) begin
                            if (~p_loc18_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc18_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc18_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc18_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc18_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc18_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc19_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc19_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc19_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc19_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc19_channel_U.if_write)) begin
                            if (~p_loc19_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc19_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc19_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc19_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc19_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc19_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc20_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc20_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc20_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc20_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc20_channel_U.if_write)) begin
                            if (~p_loc20_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc20_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc20_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc20_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc20_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc20_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc21_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc21_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc21_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc21_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc21_channel_U.if_write)) begin
                            if (~p_loc21_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc21_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc21_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc21_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc21_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc21_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc22_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc22_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc22_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc22_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc22_channel_U.if_write)) begin
                            if (~p_loc22_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc22_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc22_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc22_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc22_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc22_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc23_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc23_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc23_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc23_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc23_channel_U.if_write)) begin
                            if (~p_loc23_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc23_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc23_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc23_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc23_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc23_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc24_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc24_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc24_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc24_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc24_channel_U.if_write)) begin
                            if (~p_loc24_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc24_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc24_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc24_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc24_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc24_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.p_loc25_channel_U' info is :
// blk sig is {{~bnn_bnn_inst.p_loc25_channel_U.if_empty_n & bnn_bnn_inst.dense_layer_U0.ap_idle & ~bnn_bnn_inst.p_loc25_channel_U.if_write} TLF_FIFO}
                        if ((~p_loc25_channel_U.if_empty_n & dense_layer_U0.ap_idle & ~p_loc25_channel_U.if_write)) begin
                            if (~p_loc25_channel_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.p_loc25_channel_U' written by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc25_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~p_loc25_channel_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.p_loc25_channel_U' read by process 'bnn_bnn.Block_entry_gmem_rd_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.p_loc25_channel_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                3 : begin // for proc 'bnn_bnn.sign_and_quantize_U0'
                    case(index2)
                    2: begin //  for dep proc 'bnn_bnn.dense_layer_U0'
// for dep channel 'bnn_bnn.layer1_output_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_U.if_write} TLF_FIFO}
                        if ((~layer1_output_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_U.if_write)) begin
                            if (~layer1_output_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_1_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_1_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_1_U.if_write} TLF_FIFO}
                        if ((~layer1_output_1_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_1_U.if_write)) begin
                            if (~layer1_output_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_1_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_1_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_2_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_2_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_2_U.if_write} TLF_FIFO}
                        if ((~layer1_output_2_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_2_U.if_write)) begin
                            if (~layer1_output_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_2_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_2_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_3_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_3_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_3_U.if_write} TLF_FIFO}
                        if ((~layer1_output_3_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_3_U.if_write)) begin
                            if (~layer1_output_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_3_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_3_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_4_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_4_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_4_U.if_write} TLF_FIFO}
                        if ((~layer1_output_4_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_4_U.if_write)) begin
                            if (~layer1_output_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_4_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_4_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_5_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_5_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_5_U.if_write} TLF_FIFO}
                        if ((~layer1_output_5_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_5_U.if_write)) begin
                            if (~layer1_output_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_5_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_5_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_6_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_6_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_6_U.if_write} TLF_FIFO}
                        if ((~layer1_output_6_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_6_U.if_write)) begin
                            if (~layer1_output_6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_6_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_6_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_7_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_7_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_7_U.if_write} TLF_FIFO}
                        if ((~layer1_output_7_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_7_U.if_write)) begin
                            if (~layer1_output_7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_7_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_7_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_8_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_8_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_8_U.if_write} TLF_FIFO}
                        if ((~layer1_output_8_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_8_U.if_write)) begin
                            if (~layer1_output_8_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_8_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_8_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_8_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_9_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_9_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_9_U.if_write} TLF_FIFO}
                        if ((~layer1_output_9_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_9_U.if_write)) begin
                            if (~layer1_output_9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_9_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_9_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_10_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_10_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_10_U.if_write} TLF_FIFO}
                        if ((~layer1_output_10_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_10_U.if_write)) begin
                            if (~layer1_output_10_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_10_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_10_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_10_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_11_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_11_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_11_U.if_write} TLF_FIFO}
                        if ((~layer1_output_11_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_11_U.if_write)) begin
                            if (~layer1_output_11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_11_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_11_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_12_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_12_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_12_U.if_write} TLF_FIFO}
                        if ((~layer1_output_12_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_12_U.if_write)) begin
                            if (~layer1_output_12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_12_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_12_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_13_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_13_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_13_U.if_write} TLF_FIFO}
                        if ((~layer1_output_13_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_13_U.if_write)) begin
                            if (~layer1_output_13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_13_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_13_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_14_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_14_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_14_U.if_write} TLF_FIFO}
                        if ((~layer1_output_14_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_14_U.if_write)) begin
                            if (~layer1_output_14_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_14_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_14_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_14_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_14_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_14_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_15_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_15_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_15_U.if_write} TLF_FIFO}
                        if ((~layer1_output_15_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_15_U.if_write)) begin
                            if (~layer1_output_15_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_15_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_15_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_15_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_15_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_15_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_16_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_16_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_16_U.if_write} TLF_FIFO}
                        if ((~layer1_output_16_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_16_U.if_write)) begin
                            if (~layer1_output_16_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_16_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_16_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_16_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_16_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_16_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_17_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_17_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_17_U.if_write} TLF_FIFO}
                        if ((~layer1_output_17_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_17_U.if_write)) begin
                            if (~layer1_output_17_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_17_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_17_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_17_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_17_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_17_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_18_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_18_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_18_U.if_write} TLF_FIFO}
                        if ((~layer1_output_18_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_18_U.if_write)) begin
                            if (~layer1_output_18_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_18_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_18_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_18_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_18_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_18_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_19_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_19_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_19_U.if_write} TLF_FIFO}
                        if ((~layer1_output_19_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_19_U.if_write)) begin
                            if (~layer1_output_19_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_19_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_19_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_19_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_19_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_19_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_20_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_20_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_20_U.if_write} TLF_FIFO}
                        if ((~layer1_output_20_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_20_U.if_write)) begin
                            if (~layer1_output_20_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_20_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_20_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_20_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_20_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_20_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_21_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_21_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_21_U.if_write} TLF_FIFO}
                        if ((~layer1_output_21_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_21_U.if_write)) begin
                            if (~layer1_output_21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_21_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_21_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_22_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_22_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_22_U.if_write} TLF_FIFO}
                        if ((~layer1_output_22_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_22_U.if_write)) begin
                            if (~layer1_output_22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_22_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_22_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_23_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_23_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_23_U.if_write} TLF_FIFO}
                        if ((~layer1_output_23_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_23_U.if_write)) begin
                            if (~layer1_output_23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_23_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_23_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_24_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_24_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_24_U.if_write} TLF_FIFO}
                        if ((~layer1_output_24_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_24_U.if_write)) begin
                            if (~layer1_output_24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_24_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_24_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_25_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_25_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_25_U.if_write} TLF_FIFO}
                        if ((~layer1_output_25_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_25_U.if_write)) begin
                            if (~layer1_output_25_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_25_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_25_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_25_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_25_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_25_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_26_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_26_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_26_U.if_write} TLF_FIFO}
                        if ((~layer1_output_26_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_26_U.if_write)) begin
                            if (~layer1_output_26_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_26_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_26_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_26_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_26_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_26_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_27_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_27_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_27_U.if_write} TLF_FIFO}
                        if ((~layer1_output_27_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_27_U.if_write)) begin
                            if (~layer1_output_27_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_27_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_27_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_27_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_27_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_27_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_28_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_28_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_28_U.if_write} TLF_FIFO}
                        if ((~layer1_output_28_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_28_U.if_write)) begin
                            if (~layer1_output_28_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_28_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_28_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_28_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_28_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_28_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_29_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_29_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_29_U.if_write} TLF_FIFO}
                        if ((~layer1_output_29_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_29_U.if_write)) begin
                            if (~layer1_output_29_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_29_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_29_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_29_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_29_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_29_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_30_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_30_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_30_U.if_write} TLF_FIFO}
                        if ((~layer1_output_30_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_30_U.if_write)) begin
                            if (~layer1_output_30_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_30_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_30_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_30_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_30_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_30_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_31_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_31_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_31_U.if_write} TLF_FIFO}
                        if ((~layer1_output_31_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_31_U.if_write)) begin
                            if (~layer1_output_31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_31_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_31_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_32_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_32_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_32_U.if_write} TLF_FIFO}
                        if ((~layer1_output_32_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_32_U.if_write)) begin
                            if (~layer1_output_32_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_32_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_32_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_32_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_32_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_32_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_33_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_33_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_33_U.if_write} TLF_FIFO}
                        if ((~layer1_output_33_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_33_U.if_write)) begin
                            if (~layer1_output_33_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_33_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_33_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_33_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_33_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_33_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_34_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_34_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_34_U.if_write} TLF_FIFO}
                        if ((~layer1_output_34_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_34_U.if_write)) begin
                            if (~layer1_output_34_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_34_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_34_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_34_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_34_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_34_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_35_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_35_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_35_U.if_write} TLF_FIFO}
                        if ((~layer1_output_35_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_35_U.if_write)) begin
                            if (~layer1_output_35_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_35_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_35_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_35_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_35_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_35_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_36_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_36_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_36_U.if_write} TLF_FIFO}
                        if ((~layer1_output_36_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_36_U.if_write)) begin
                            if (~layer1_output_36_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_36_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_36_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_36_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_36_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_36_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_37_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_37_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_37_U.if_write} TLF_FIFO}
                        if ((~layer1_output_37_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_37_U.if_write)) begin
                            if (~layer1_output_37_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_37_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_37_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_37_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_37_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_37_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_38_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_38_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_38_U.if_write} TLF_FIFO}
                        if ((~layer1_output_38_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_38_U.if_write)) begin
                            if (~layer1_output_38_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_38_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_38_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_38_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_38_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_38_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_39_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_39_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_39_U.if_write} TLF_FIFO}
                        if ((~layer1_output_39_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_39_U.if_write)) begin
                            if (~layer1_output_39_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_39_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_39_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_39_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_39_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_39_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_40_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_40_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_40_U.if_write} TLF_FIFO}
                        if ((~layer1_output_40_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_40_U.if_write)) begin
                            if (~layer1_output_40_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_40_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_40_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_40_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_40_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_40_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_41_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_41_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_41_U.if_write} TLF_FIFO}
                        if ((~layer1_output_41_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_41_U.if_write)) begin
                            if (~layer1_output_41_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_41_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_41_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_41_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_41_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_41_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_42_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_42_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_42_U.if_write} TLF_FIFO}
                        if ((~layer1_output_42_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_42_U.if_write)) begin
                            if (~layer1_output_42_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_42_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_42_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_42_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_42_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_42_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_43_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_43_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_43_U.if_write} TLF_FIFO}
                        if ((~layer1_output_43_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_43_U.if_write)) begin
                            if (~layer1_output_43_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_43_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_43_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_43_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_43_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_43_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_44_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_44_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_44_U.if_write} TLF_FIFO}
                        if ((~layer1_output_44_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_44_U.if_write)) begin
                            if (~layer1_output_44_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_44_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_44_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_44_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_44_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_44_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_45_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_45_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_45_U.if_write} TLF_FIFO}
                        if ((~layer1_output_45_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_45_U.if_write)) begin
                            if (~layer1_output_45_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_45_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_45_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_45_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_45_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_45_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_46_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_46_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_46_U.if_write} TLF_FIFO}
                        if ((~layer1_output_46_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_46_U.if_write)) begin
                            if (~layer1_output_46_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_46_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_46_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_46_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_46_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_46_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_47_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_47_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_47_U.if_write} TLF_FIFO}
                        if ((~layer1_output_47_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_47_U.if_write)) begin
                            if (~layer1_output_47_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_47_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_47_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_47_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_47_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_47_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_48_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_48_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_48_U.if_write} TLF_FIFO}
                        if ((~layer1_output_48_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_48_U.if_write)) begin
                            if (~layer1_output_48_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_48_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_48_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_48_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_48_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_48_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_49_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_49_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_49_U.if_write} TLF_FIFO}
                        if ((~layer1_output_49_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_49_U.if_write)) begin
                            if (~layer1_output_49_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_49_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_49_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_49_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_49_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_49_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_50_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_50_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_50_U.if_write} TLF_FIFO}
                        if ((~layer1_output_50_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_50_U.if_write)) begin
                            if (~layer1_output_50_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_50_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_50_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_50_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_50_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_50_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_51_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_51_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_51_U.if_write} TLF_FIFO}
                        if ((~layer1_output_51_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_51_U.if_write)) begin
                            if (~layer1_output_51_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_51_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_51_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_51_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_51_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_51_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_52_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_52_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_52_U.if_write} TLF_FIFO}
                        if ((~layer1_output_52_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_52_U.if_write)) begin
                            if (~layer1_output_52_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_52_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_52_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_52_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_52_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_52_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_53_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_53_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_53_U.if_write} TLF_FIFO}
                        if ((~layer1_output_53_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_53_U.if_write)) begin
                            if (~layer1_output_53_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_53_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_53_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_53_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_53_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_53_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_54_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_54_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_54_U.if_write} TLF_FIFO}
                        if ((~layer1_output_54_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_54_U.if_write)) begin
                            if (~layer1_output_54_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_54_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_54_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_54_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_54_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_54_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_55_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_55_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_55_U.if_write} TLF_FIFO}
                        if ((~layer1_output_55_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_55_U.if_write)) begin
                            if (~layer1_output_55_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_55_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_55_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_55_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_55_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_55_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_56_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_56_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_56_U.if_write} TLF_FIFO}
                        if ((~layer1_output_56_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_56_U.if_write)) begin
                            if (~layer1_output_56_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_56_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_56_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_56_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_56_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_56_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_57_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_57_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_57_U.if_write} TLF_FIFO}
                        if ((~layer1_output_57_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_57_U.if_write)) begin
                            if (~layer1_output_57_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_57_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_57_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_57_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_57_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_57_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_58_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_58_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_58_U.if_write} TLF_FIFO}
                        if ((~layer1_output_58_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_58_U.if_write)) begin
                            if (~layer1_output_58_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_58_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_58_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_58_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_58_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_58_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_59_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_59_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_59_U.if_write} TLF_FIFO}
                        if ((~layer1_output_59_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_59_U.if_write)) begin
                            if (~layer1_output_59_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_59_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_59_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_59_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_59_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_59_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_60_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_60_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_60_U.if_write} TLF_FIFO}
                        if ((~layer1_output_60_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_60_U.if_write)) begin
                            if (~layer1_output_60_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_60_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_60_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_60_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_60_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_60_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_61_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_61_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_61_U.if_write} TLF_FIFO}
                        if ((~layer1_output_61_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_61_U.if_write)) begin
                            if (~layer1_output_61_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_61_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_61_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_61_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_61_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_61_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_62_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_62_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_62_U.if_write} TLF_FIFO}
                        if ((~layer1_output_62_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_62_U.if_write)) begin
                            if (~layer1_output_62_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_62_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_62_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_62_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_62_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_62_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_63_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_63_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_63_U.if_write} TLF_FIFO}
                        if ((~layer1_output_63_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_63_U.if_write)) begin
                            if (~layer1_output_63_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_63_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_63_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_63_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_63_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_63_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_64_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_64_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_64_U.if_write} TLF_FIFO}
                        if ((~layer1_output_64_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_64_U.if_write)) begin
                            if (~layer1_output_64_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_64_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_64_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_64_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_64_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_64_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_65_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_65_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_65_U.if_write} TLF_FIFO}
                        if ((~layer1_output_65_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_65_U.if_write)) begin
                            if (~layer1_output_65_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_65_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_65_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_65_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_65_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_65_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_66_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_66_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_66_U.if_write} TLF_FIFO}
                        if ((~layer1_output_66_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_66_U.if_write)) begin
                            if (~layer1_output_66_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_66_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_66_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_66_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_66_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_66_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_67_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_67_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_67_U.if_write} TLF_FIFO}
                        if ((~layer1_output_67_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_67_U.if_write)) begin
                            if (~layer1_output_67_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_67_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_67_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_67_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_67_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_67_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_68_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_68_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_68_U.if_write} TLF_FIFO}
                        if ((~layer1_output_68_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_68_U.if_write)) begin
                            if (~layer1_output_68_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_68_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_68_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_68_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_68_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_68_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_69_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_69_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_69_U.if_write} TLF_FIFO}
                        if ((~layer1_output_69_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_69_U.if_write)) begin
                            if (~layer1_output_69_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_69_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_69_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_69_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_69_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_69_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_70_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_70_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_70_U.if_write} TLF_FIFO}
                        if ((~layer1_output_70_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_70_U.if_write)) begin
                            if (~layer1_output_70_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_70_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_70_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_70_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_70_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_70_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_71_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_71_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_71_U.if_write} TLF_FIFO}
                        if ((~layer1_output_71_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_71_U.if_write)) begin
                            if (~layer1_output_71_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_71_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_71_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_71_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_71_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_71_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_72_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_72_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_72_U.if_write} TLF_FIFO}
                        if ((~layer1_output_72_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_72_U.if_write)) begin
                            if (~layer1_output_72_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_72_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_72_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_72_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_72_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_72_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_73_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_73_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_73_U.if_write} TLF_FIFO}
                        if ((~layer1_output_73_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_73_U.if_write)) begin
                            if (~layer1_output_73_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_73_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_73_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_73_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_73_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_73_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_74_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_74_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_74_U.if_write} TLF_FIFO}
                        if ((~layer1_output_74_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_74_U.if_write)) begin
                            if (~layer1_output_74_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_74_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_74_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_74_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_74_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_74_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_75_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_75_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_75_U.if_write} TLF_FIFO}
                        if ((~layer1_output_75_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_75_U.if_write)) begin
                            if (~layer1_output_75_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_75_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_75_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_75_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_75_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_75_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_76_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_76_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_76_U.if_write} TLF_FIFO}
                        if ((~layer1_output_76_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_76_U.if_write)) begin
                            if (~layer1_output_76_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_76_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_76_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_76_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_76_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_76_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_77_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_77_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_77_U.if_write} TLF_FIFO}
                        if ((~layer1_output_77_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_77_U.if_write)) begin
                            if (~layer1_output_77_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_77_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_77_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_77_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_77_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_77_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_78_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_78_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_78_U.if_write} TLF_FIFO}
                        if ((~layer1_output_78_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_78_U.if_write)) begin
                            if (~layer1_output_78_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_78_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_78_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_78_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_78_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_78_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_79_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_79_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_79_U.if_write} TLF_FIFO}
                        if ((~layer1_output_79_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_79_U.if_write)) begin
                            if (~layer1_output_79_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_79_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_79_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_79_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_79_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_79_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_80_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_80_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_80_U.if_write} TLF_FIFO}
                        if ((~layer1_output_80_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_80_U.if_write)) begin
                            if (~layer1_output_80_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_80_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_80_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_80_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_80_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_80_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_81_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_81_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_81_U.if_write} TLF_FIFO}
                        if ((~layer1_output_81_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_81_U.if_write)) begin
                            if (~layer1_output_81_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_81_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_81_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_81_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_81_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_81_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_82_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_82_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_82_U.if_write} TLF_FIFO}
                        if ((~layer1_output_82_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_82_U.if_write)) begin
                            if (~layer1_output_82_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_82_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_82_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_82_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_82_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_82_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_83_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_83_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_83_U.if_write} TLF_FIFO}
                        if ((~layer1_output_83_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_83_U.if_write)) begin
                            if (~layer1_output_83_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_83_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_83_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_83_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_83_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_83_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_84_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_84_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_84_U.if_write} TLF_FIFO}
                        if ((~layer1_output_84_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_84_U.if_write)) begin
                            if (~layer1_output_84_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_84_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_84_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_84_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_84_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_84_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_85_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_85_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_85_U.if_write} TLF_FIFO}
                        if ((~layer1_output_85_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_85_U.if_write)) begin
                            if (~layer1_output_85_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_85_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_85_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_85_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_85_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_85_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_86_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_86_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_86_U.if_write} TLF_FIFO}
                        if ((~layer1_output_86_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_86_U.if_write)) begin
                            if (~layer1_output_86_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_86_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_86_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_86_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_86_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_86_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_87_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_87_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_87_U.if_write} TLF_FIFO}
                        if ((~layer1_output_87_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_87_U.if_write)) begin
                            if (~layer1_output_87_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_87_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_87_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_87_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_87_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_87_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_88_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_88_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_88_U.if_write} TLF_FIFO}
                        if ((~layer1_output_88_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_88_U.if_write)) begin
                            if (~layer1_output_88_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_88_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_88_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_88_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_88_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_88_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_89_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_89_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_89_U.if_write} TLF_FIFO}
                        if ((~layer1_output_89_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_89_U.if_write)) begin
                            if (~layer1_output_89_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_89_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_89_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_89_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_89_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_89_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_90_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_90_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_90_U.if_write} TLF_FIFO}
                        if ((~layer1_output_90_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_90_U.if_write)) begin
                            if (~layer1_output_90_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_90_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_90_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_90_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_90_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_90_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_91_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_91_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_91_U.if_write} TLF_FIFO}
                        if ((~layer1_output_91_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_91_U.if_write)) begin
                            if (~layer1_output_91_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_91_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_91_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_91_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_91_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_91_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_92_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_92_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_92_U.if_write} TLF_FIFO}
                        if ((~layer1_output_92_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_92_U.if_write)) begin
                            if (~layer1_output_92_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_92_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_92_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_92_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_92_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_92_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_93_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_93_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_93_U.if_write} TLF_FIFO}
                        if ((~layer1_output_93_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_93_U.if_write)) begin
                            if (~layer1_output_93_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_93_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_93_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_93_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_93_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_93_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_94_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_94_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_94_U.if_write} TLF_FIFO}
                        if ((~layer1_output_94_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_94_U.if_write)) begin
                            if (~layer1_output_94_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_94_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_94_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_94_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_94_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_94_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_95_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_95_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_95_U.if_write} TLF_FIFO}
                        if ((~layer1_output_95_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_95_U.if_write)) begin
                            if (~layer1_output_95_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_95_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_95_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_95_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_95_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_95_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_96_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_96_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_96_U.if_write} TLF_FIFO}
                        if ((~layer1_output_96_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_96_U.if_write)) begin
                            if (~layer1_output_96_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_96_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_96_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_96_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_96_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_96_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_97_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_97_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_97_U.if_write} TLF_FIFO}
                        if ((~layer1_output_97_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_97_U.if_write)) begin
                            if (~layer1_output_97_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_97_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_97_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_97_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_97_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_97_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_98_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_98_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_98_U.if_write} TLF_FIFO}
                        if ((~layer1_output_98_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_98_U.if_write)) begin
                            if (~layer1_output_98_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_98_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_98_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_98_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_98_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_98_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_99_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_99_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_99_U.if_write} TLF_FIFO}
                        if ((~layer1_output_99_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_99_U.if_write)) begin
                            if (~layer1_output_99_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_99_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_99_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_99_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_99_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_99_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_100_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_100_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_100_U.if_write} TLF_FIFO}
                        if ((~layer1_output_100_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_100_U.if_write)) begin
                            if (~layer1_output_100_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_100_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_100_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_100_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_100_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_100_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_101_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_101_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_101_U.if_write} TLF_FIFO}
                        if ((~layer1_output_101_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_101_U.if_write)) begin
                            if (~layer1_output_101_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_101_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_101_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_101_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_101_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_101_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_102_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_102_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_102_U.if_write} TLF_FIFO}
                        if ((~layer1_output_102_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_102_U.if_write)) begin
                            if (~layer1_output_102_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_102_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_102_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_102_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_102_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_102_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_103_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_103_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_103_U.if_write} TLF_FIFO}
                        if ((~layer1_output_103_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_103_U.if_write)) begin
                            if (~layer1_output_103_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_103_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_103_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_103_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_103_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_103_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_104_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_104_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_104_U.if_write} TLF_FIFO}
                        if ((~layer1_output_104_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_104_U.if_write)) begin
                            if (~layer1_output_104_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_104_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_104_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_104_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_104_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_104_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_105_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_105_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_105_U.if_write} TLF_FIFO}
                        if ((~layer1_output_105_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_105_U.if_write)) begin
                            if (~layer1_output_105_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_105_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_105_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_105_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_105_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_105_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_106_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_106_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_106_U.if_write} TLF_FIFO}
                        if ((~layer1_output_106_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_106_U.if_write)) begin
                            if (~layer1_output_106_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_106_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_106_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_106_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_106_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_106_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_107_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_107_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_107_U.if_write} TLF_FIFO}
                        if ((~layer1_output_107_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_107_U.if_write)) begin
                            if (~layer1_output_107_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_107_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_107_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_107_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_107_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_107_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_108_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_108_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_108_U.if_write} TLF_FIFO}
                        if ((~layer1_output_108_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_108_U.if_write)) begin
                            if (~layer1_output_108_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_108_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_108_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_108_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_108_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_108_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_109_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_109_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_109_U.if_write} TLF_FIFO}
                        if ((~layer1_output_109_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_109_U.if_write)) begin
                            if (~layer1_output_109_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_109_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_109_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_109_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_109_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_109_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_110_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_110_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_110_U.if_write} TLF_FIFO}
                        if ((~layer1_output_110_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_110_U.if_write)) begin
                            if (~layer1_output_110_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_110_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_110_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_110_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_110_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_110_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_111_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_111_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_111_U.if_write} TLF_FIFO}
                        if ((~layer1_output_111_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_111_U.if_write)) begin
                            if (~layer1_output_111_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_111_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_111_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_111_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_111_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_111_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_112_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_112_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_112_U.if_write} TLF_FIFO}
                        if ((~layer1_output_112_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_112_U.if_write)) begin
                            if (~layer1_output_112_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_112_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_112_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_112_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_112_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_112_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_113_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_113_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_113_U.if_write} TLF_FIFO}
                        if ((~layer1_output_113_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_113_U.if_write)) begin
                            if (~layer1_output_113_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_113_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_113_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_113_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_113_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_113_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_114_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_114_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_114_U.if_write} TLF_FIFO}
                        if ((~layer1_output_114_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_114_U.if_write)) begin
                            if (~layer1_output_114_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_114_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_114_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_114_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_114_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_114_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_115_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_115_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_115_U.if_write} TLF_FIFO}
                        if ((~layer1_output_115_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_115_U.if_write)) begin
                            if (~layer1_output_115_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_115_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_115_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_115_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_115_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_115_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_116_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_116_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_116_U.if_write} TLF_FIFO}
                        if ((~layer1_output_116_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_116_U.if_write)) begin
                            if (~layer1_output_116_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_116_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_116_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_116_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_116_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_116_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_117_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_117_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_117_U.if_write} TLF_FIFO}
                        if ((~layer1_output_117_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_117_U.if_write)) begin
                            if (~layer1_output_117_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_117_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_117_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_117_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_117_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_117_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_118_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_118_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_118_U.if_write} TLF_FIFO}
                        if ((~layer1_output_118_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_118_U.if_write)) begin
                            if (~layer1_output_118_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_118_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_118_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_118_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_118_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_118_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_119_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_119_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_119_U.if_write} TLF_FIFO}
                        if ((~layer1_output_119_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_119_U.if_write)) begin
                            if (~layer1_output_119_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_119_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_119_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_119_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_119_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_119_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_120_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_120_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_120_U.if_write} TLF_FIFO}
                        if ((~layer1_output_120_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_120_U.if_write)) begin
                            if (~layer1_output_120_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_120_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_120_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_120_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_120_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_120_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_121_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_121_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_121_U.if_write} TLF_FIFO}
                        if ((~layer1_output_121_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_121_U.if_write)) begin
                            if (~layer1_output_121_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_121_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_121_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_121_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_121_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_121_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_122_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_122_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_122_U.if_write} TLF_FIFO}
                        if ((~layer1_output_122_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_122_U.if_write)) begin
                            if (~layer1_output_122_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_122_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_122_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_122_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_122_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_122_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_123_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_123_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_123_U.if_write} TLF_FIFO}
                        if ((~layer1_output_123_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_123_U.if_write)) begin
                            if (~layer1_output_123_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_123_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_123_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_123_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_123_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_123_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_124_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_124_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_124_U.if_write} TLF_FIFO}
                        if ((~layer1_output_124_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_124_U.if_write)) begin
                            if (~layer1_output_124_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_124_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_124_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_124_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_124_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_124_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_125_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_125_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_125_U.if_write} TLF_FIFO}
                        if ((~layer1_output_125_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_125_U.if_write)) begin
                            if (~layer1_output_125_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_125_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_125_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_125_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_125_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_125_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_126_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_126_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_126_U.if_write} TLF_FIFO}
                        if ((~layer1_output_126_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_126_U.if_write)) begin
                            if (~layer1_output_126_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_126_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_126_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_126_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_126_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_126_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_output_127_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_output_127_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_U0.ap_idle & ~bnn_bnn_inst.layer1_output_127_U.if_write} TLF_FIFO}
                        if ((~layer1_output_127_U.if_empty_n & sign_and_quantize_U0.ap_idle & ~layer1_output_127_U.if_write)) begin
                            if (~layer1_output_127_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_output_127_U' written by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_127_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_output_127_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_output_127_U' read by process 'bnn_bnn.dense_layer_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_output_127_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                4 : begin // for proc 'bnn_bnn.dense_layer_1_U0'
                    case(index2)
                    3: begin //  for dep proc 'bnn_bnn.sign_and_quantize_U0'
// for dep channel 'bnn_bnn.layer1_quantized_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_quantized_U.if_empty_n & bnn_bnn_inst.dense_layer_1_U0.ap_idle & ~bnn_bnn_inst.layer1_quantized_U.if_write} TLF_FIFO}
                        if ((~layer1_quantized_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_U.if_write)) begin
                            if (~layer1_quantized_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_quantized_U' written by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_quantized_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_quantized_U' read by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_quantized_1_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_quantized_1_U.if_empty_n & bnn_bnn_inst.dense_layer_1_U0.ap_idle & ~bnn_bnn_inst.layer1_quantized_1_U.if_write} TLF_FIFO}
                        if ((~layer1_quantized_1_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_1_U.if_write)) begin
                            if (~layer1_quantized_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_quantized_1_U' written by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_quantized_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_quantized_1_U' read by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_quantized_2_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_quantized_2_U.if_empty_n & bnn_bnn_inst.dense_layer_1_U0.ap_idle & ~bnn_bnn_inst.layer1_quantized_2_U.if_write} TLF_FIFO}
                        if ((~layer1_quantized_2_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_2_U.if_write)) begin
                            if (~layer1_quantized_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_quantized_2_U' written by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_quantized_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_quantized_2_U' read by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer1_quantized_3_U' info is :
// blk sig is {{~bnn_bnn_inst.layer1_quantized_3_U.if_empty_n & bnn_bnn_inst.dense_layer_1_U0.ap_idle & ~bnn_bnn_inst.layer1_quantized_3_U.if_write} TLF_FIFO}
                        if ((~layer1_quantized_3_U.if_empty_n & dense_layer_1_U0.ap_idle & ~layer1_quantized_3_U.if_write)) begin
                            if (~layer1_quantized_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer1_quantized_3_U' written by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer1_quantized_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer1_quantized_3_U' read by process 'bnn_bnn.sign_and_quantize_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer1_quantized_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                5 : begin // for proc 'bnn_bnn.sign_and_quantize_2_U0'
                    case(index2)
                    4: begin //  for dep proc 'bnn_bnn.dense_layer_1_U0'
// for dep channel 'bnn_bnn.layer2_output_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_U.if_write} TLF_FIFO}
                        if ((~layer2_output_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_U.if_write)) begin
                            if (~layer2_output_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_1_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_1_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_1_U.if_write} TLF_FIFO}
                        if ((~layer2_output_1_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_1_U.if_write)) begin
                            if (~layer2_output_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_1_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_1_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_2_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_2_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_2_U.if_write} TLF_FIFO}
                        if ((~layer2_output_2_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_2_U.if_write)) begin
                            if (~layer2_output_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_2_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_2_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_3_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_3_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_3_U.if_write} TLF_FIFO}
                        if ((~layer2_output_3_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_3_U.if_write)) begin
                            if (~layer2_output_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_3_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_3_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_4_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_4_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_4_U.if_write} TLF_FIFO}
                        if ((~layer2_output_4_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_4_U.if_write)) begin
                            if (~layer2_output_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_4_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_4_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_5_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_5_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_5_U.if_write} TLF_FIFO}
                        if ((~layer2_output_5_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_5_U.if_write)) begin
                            if (~layer2_output_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_5_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_5_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_6_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_6_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_6_U.if_write} TLF_FIFO}
                        if ((~layer2_output_6_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_6_U.if_write)) begin
                            if (~layer2_output_6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_6_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_6_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_7_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_7_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_7_U.if_write} TLF_FIFO}
                        if ((~layer2_output_7_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_7_U.if_write)) begin
                            if (~layer2_output_7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_7_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_7_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_8_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_8_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_8_U.if_write} TLF_FIFO}
                        if ((~layer2_output_8_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_8_U.if_write)) begin
                            if (~layer2_output_8_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_8_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_8_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_8_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_9_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_9_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_9_U.if_write} TLF_FIFO}
                        if ((~layer2_output_9_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_9_U.if_write)) begin
                            if (~layer2_output_9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_9_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_9_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_10_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_10_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_10_U.if_write} TLF_FIFO}
                        if ((~layer2_output_10_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_10_U.if_write)) begin
                            if (~layer2_output_10_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_10_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_10_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_10_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_11_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_11_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_11_U.if_write} TLF_FIFO}
                        if ((~layer2_output_11_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_11_U.if_write)) begin
                            if (~layer2_output_11_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_11_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_11_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_11_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_12_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_12_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_12_U.if_write} TLF_FIFO}
                        if ((~layer2_output_12_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_12_U.if_write)) begin
                            if (~layer2_output_12_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_12_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_12_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_12_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_13_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_13_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_13_U.if_write} TLF_FIFO}
                        if ((~layer2_output_13_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_13_U.if_write)) begin
                            if (~layer2_output_13_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_13_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_13_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_13_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_13_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_13_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_14_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_14_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_14_U.if_write} TLF_FIFO}
                        if ((~layer2_output_14_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_14_U.if_write)) begin
                            if (~layer2_output_14_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_14_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_14_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_14_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_14_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_14_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_15_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_15_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_15_U.if_write} TLF_FIFO}
                        if ((~layer2_output_15_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_15_U.if_write)) begin
                            if (~layer2_output_15_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_15_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_15_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_15_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_15_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_15_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_16_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_16_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_16_U.if_write} TLF_FIFO}
                        if ((~layer2_output_16_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_16_U.if_write)) begin
                            if (~layer2_output_16_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_16_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_16_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_16_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_16_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_16_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_17_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_17_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_17_U.if_write} TLF_FIFO}
                        if ((~layer2_output_17_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_17_U.if_write)) begin
                            if (~layer2_output_17_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_17_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_17_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_17_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_17_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_17_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_18_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_18_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_18_U.if_write} TLF_FIFO}
                        if ((~layer2_output_18_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_18_U.if_write)) begin
                            if (~layer2_output_18_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_18_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_18_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_18_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_18_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_18_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_19_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_19_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_19_U.if_write} TLF_FIFO}
                        if ((~layer2_output_19_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_19_U.if_write)) begin
                            if (~layer2_output_19_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_19_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_19_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_19_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_19_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_19_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_20_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_20_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_20_U.if_write} TLF_FIFO}
                        if ((~layer2_output_20_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_20_U.if_write)) begin
                            if (~layer2_output_20_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_20_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_20_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_20_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_20_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_20_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_21_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_21_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_21_U.if_write} TLF_FIFO}
                        if ((~layer2_output_21_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_21_U.if_write)) begin
                            if (~layer2_output_21_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_21_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_21_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_21_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_21_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_21_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_22_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_22_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_22_U.if_write} TLF_FIFO}
                        if ((~layer2_output_22_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_22_U.if_write)) begin
                            if (~layer2_output_22_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_22_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_22_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_22_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_22_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_22_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_23_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_23_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_23_U.if_write} TLF_FIFO}
                        if ((~layer2_output_23_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_23_U.if_write)) begin
                            if (~layer2_output_23_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_23_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_23_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_23_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_23_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_23_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_24_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_24_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_24_U.if_write} TLF_FIFO}
                        if ((~layer2_output_24_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_24_U.if_write)) begin
                            if (~layer2_output_24_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_24_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_24_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_24_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_24_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_24_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_25_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_25_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_25_U.if_write} TLF_FIFO}
                        if ((~layer2_output_25_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_25_U.if_write)) begin
                            if (~layer2_output_25_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_25_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_25_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_25_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_25_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_25_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_26_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_26_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_26_U.if_write} TLF_FIFO}
                        if ((~layer2_output_26_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_26_U.if_write)) begin
                            if (~layer2_output_26_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_26_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_26_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_26_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_26_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_26_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_27_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_27_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_27_U.if_write} TLF_FIFO}
                        if ((~layer2_output_27_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_27_U.if_write)) begin
                            if (~layer2_output_27_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_27_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_27_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_27_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_27_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_27_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_28_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_28_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_28_U.if_write} TLF_FIFO}
                        if ((~layer2_output_28_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_28_U.if_write)) begin
                            if (~layer2_output_28_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_28_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_28_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_28_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_28_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_28_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_29_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_29_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_29_U.if_write} TLF_FIFO}
                        if ((~layer2_output_29_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_29_U.if_write)) begin
                            if (~layer2_output_29_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_29_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_29_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_29_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_29_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_29_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_30_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_30_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_30_U.if_write} TLF_FIFO}
                        if ((~layer2_output_30_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_30_U.if_write)) begin
                            if (~layer2_output_30_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_30_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_30_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_30_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_30_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_30_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_31_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_31_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_31_U.if_write} TLF_FIFO}
                        if ((~layer2_output_31_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_31_U.if_write)) begin
                            if (~layer2_output_31_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_31_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_31_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_31_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_31_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_31_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_32_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_32_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_32_U.if_write} TLF_FIFO}
                        if ((~layer2_output_32_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_32_U.if_write)) begin
                            if (~layer2_output_32_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_32_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_32_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_32_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_32_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_32_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_33_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_33_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_33_U.if_write} TLF_FIFO}
                        if ((~layer2_output_33_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_33_U.if_write)) begin
                            if (~layer2_output_33_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_33_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_33_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_33_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_33_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_33_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_34_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_34_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_34_U.if_write} TLF_FIFO}
                        if ((~layer2_output_34_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_34_U.if_write)) begin
                            if (~layer2_output_34_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_34_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_34_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_34_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_34_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_34_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_35_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_35_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_35_U.if_write} TLF_FIFO}
                        if ((~layer2_output_35_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_35_U.if_write)) begin
                            if (~layer2_output_35_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_35_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_35_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_35_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_35_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_35_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_36_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_36_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_36_U.if_write} TLF_FIFO}
                        if ((~layer2_output_36_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_36_U.if_write)) begin
                            if (~layer2_output_36_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_36_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_36_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_36_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_36_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_36_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_37_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_37_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_37_U.if_write} TLF_FIFO}
                        if ((~layer2_output_37_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_37_U.if_write)) begin
                            if (~layer2_output_37_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_37_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_37_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_37_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_37_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_37_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_38_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_38_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_38_U.if_write} TLF_FIFO}
                        if ((~layer2_output_38_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_38_U.if_write)) begin
                            if (~layer2_output_38_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_38_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_38_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_38_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_38_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_38_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_39_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_39_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_39_U.if_write} TLF_FIFO}
                        if ((~layer2_output_39_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_39_U.if_write)) begin
                            if (~layer2_output_39_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_39_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_39_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_39_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_39_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_39_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_40_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_40_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_40_U.if_write} TLF_FIFO}
                        if ((~layer2_output_40_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_40_U.if_write)) begin
                            if (~layer2_output_40_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_40_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_40_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_40_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_40_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_40_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_41_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_41_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_41_U.if_write} TLF_FIFO}
                        if ((~layer2_output_41_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_41_U.if_write)) begin
                            if (~layer2_output_41_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_41_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_41_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_41_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_41_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_41_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_42_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_42_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_42_U.if_write} TLF_FIFO}
                        if ((~layer2_output_42_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_42_U.if_write)) begin
                            if (~layer2_output_42_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_42_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_42_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_42_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_42_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_42_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_43_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_43_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_43_U.if_write} TLF_FIFO}
                        if ((~layer2_output_43_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_43_U.if_write)) begin
                            if (~layer2_output_43_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_43_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_43_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_43_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_43_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_43_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_44_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_44_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_44_U.if_write} TLF_FIFO}
                        if ((~layer2_output_44_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_44_U.if_write)) begin
                            if (~layer2_output_44_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_44_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_44_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_44_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_44_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_44_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_45_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_45_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_45_U.if_write} TLF_FIFO}
                        if ((~layer2_output_45_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_45_U.if_write)) begin
                            if (~layer2_output_45_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_45_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_45_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_45_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_45_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_45_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_46_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_46_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_46_U.if_write} TLF_FIFO}
                        if ((~layer2_output_46_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_46_U.if_write)) begin
                            if (~layer2_output_46_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_46_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_46_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_46_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_46_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_46_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_47_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_47_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_47_U.if_write} TLF_FIFO}
                        if ((~layer2_output_47_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_47_U.if_write)) begin
                            if (~layer2_output_47_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_47_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_47_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_47_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_47_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_47_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_48_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_48_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_48_U.if_write} TLF_FIFO}
                        if ((~layer2_output_48_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_48_U.if_write)) begin
                            if (~layer2_output_48_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_48_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_48_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_48_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_48_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_48_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_49_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_49_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_49_U.if_write} TLF_FIFO}
                        if ((~layer2_output_49_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_49_U.if_write)) begin
                            if (~layer2_output_49_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_49_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_49_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_49_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_49_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_49_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_50_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_50_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_50_U.if_write} TLF_FIFO}
                        if ((~layer2_output_50_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_50_U.if_write)) begin
                            if (~layer2_output_50_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_50_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_50_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_50_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_50_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_50_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_51_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_51_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_51_U.if_write} TLF_FIFO}
                        if ((~layer2_output_51_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_51_U.if_write)) begin
                            if (~layer2_output_51_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_51_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_51_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_51_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_51_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_51_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_52_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_52_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_52_U.if_write} TLF_FIFO}
                        if ((~layer2_output_52_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_52_U.if_write)) begin
                            if (~layer2_output_52_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_52_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_52_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_52_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_52_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_52_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_53_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_53_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_53_U.if_write} TLF_FIFO}
                        if ((~layer2_output_53_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_53_U.if_write)) begin
                            if (~layer2_output_53_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_53_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_53_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_53_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_53_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_53_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_54_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_54_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_54_U.if_write} TLF_FIFO}
                        if ((~layer2_output_54_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_54_U.if_write)) begin
                            if (~layer2_output_54_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_54_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_54_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_54_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_54_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_54_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_55_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_55_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_55_U.if_write} TLF_FIFO}
                        if ((~layer2_output_55_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_55_U.if_write)) begin
                            if (~layer2_output_55_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_55_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_55_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_55_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_55_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_55_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_56_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_56_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_56_U.if_write} TLF_FIFO}
                        if ((~layer2_output_56_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_56_U.if_write)) begin
                            if (~layer2_output_56_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_56_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_56_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_56_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_56_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_56_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_57_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_57_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_57_U.if_write} TLF_FIFO}
                        if ((~layer2_output_57_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_57_U.if_write)) begin
                            if (~layer2_output_57_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_57_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_57_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_57_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_57_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_57_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_58_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_58_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_58_U.if_write} TLF_FIFO}
                        if ((~layer2_output_58_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_58_U.if_write)) begin
                            if (~layer2_output_58_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_58_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_58_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_58_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_58_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_58_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_59_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_59_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_59_U.if_write} TLF_FIFO}
                        if ((~layer2_output_59_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_59_U.if_write)) begin
                            if (~layer2_output_59_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_59_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_59_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_59_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_59_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_59_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_60_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_60_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_60_U.if_write} TLF_FIFO}
                        if ((~layer2_output_60_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_60_U.if_write)) begin
                            if (~layer2_output_60_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_60_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_60_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_60_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_60_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_60_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_61_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_61_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_61_U.if_write} TLF_FIFO}
                        if ((~layer2_output_61_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_61_U.if_write)) begin
                            if (~layer2_output_61_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_61_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_61_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_61_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_61_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_61_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_62_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_62_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_62_U.if_write} TLF_FIFO}
                        if ((~layer2_output_62_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_62_U.if_write)) begin
                            if (~layer2_output_62_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_62_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_62_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_62_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_62_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_62_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_output_63_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_output_63_U.if_empty_n & bnn_bnn_inst.sign_and_quantize_2_U0.ap_idle & ~bnn_bnn_inst.layer2_output_63_U.if_write} TLF_FIFO}
                        if ((~layer2_output_63_U.if_empty_n & sign_and_quantize_2_U0.ap_idle & ~layer2_output_63_U.if_write)) begin
                            if (~layer2_output_63_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_output_63_U' written by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_63_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_output_63_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_output_63_U' read by process 'bnn_bnn.dense_layer_1_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_output_63_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                6 : begin // for proc 'bnn_bnn.dense_layer_3_U0'
                    case(index2)
                    5: begin //  for dep proc 'bnn_bnn.sign_and_quantize_2_U0'
// for dep channel 'bnn_bnn.layer2_quantized_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_quantized_U.if_empty_n & bnn_bnn_inst.dense_layer_3_U0.ap_idle & ~bnn_bnn_inst.layer2_quantized_U.if_write} TLF_FIFO}
                        if ((~layer2_quantized_U.if_empty_n & dense_layer_3_U0.ap_idle & ~layer2_quantized_U.if_write)) begin
                            if (~layer2_quantized_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_quantized_U' written by process 'bnn_bnn.sign_and_quantize_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_quantized_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_quantized_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_quantized_U' read by process 'bnn_bnn.sign_and_quantize_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_quantized_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer2_quantized_1_U' info is :
// blk sig is {{~bnn_bnn_inst.layer2_quantized_1_U.if_empty_n & bnn_bnn_inst.dense_layer_3_U0.ap_idle & ~bnn_bnn_inst.layer2_quantized_1_U.if_write} TLF_FIFO}
                        if ((~layer2_quantized_1_U.if_empty_n & dense_layer_3_U0.ap_idle & ~layer2_quantized_1_U.if_write)) begin
                            if (~layer2_quantized_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer2_quantized_1_U' written by process 'bnn_bnn.sign_and_quantize_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_quantized_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer2_quantized_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer2_quantized_1_U' read by process 'bnn_bnn.sign_and_quantize_2_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer2_quantized_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                7 : begin // for proc 'bnn_bnn.Block_entry_gmem_wr_proc_U0'
                    case(index2)
                    0: begin //  for dep proc 'bnn_bnn.entry_proc_U0'
// for dep channel 'bnn_bnn.ys_c_U' info is :
// blk sig is {~bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ys_blk_n data_FIFO}
                        if ((~Block_entry_gmem_wr_proc_U0.ys_blk_n)) begin
                            if (~ys_c_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.ys_c_U' written by process 'bnn_bnn.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.ys_c_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~ys_c_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.ys_c_U' read by process 'bnn_bnn.entry_proc_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.ys_c_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin //  for dep proc 'bnn_bnn.dense_layer_3_U0'
// for dep channel 'bnn_bnn.layer3_output_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_U.if_write} TLF_FIFO}
                        if ((~layer3_output_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_U.if_write)) begin
                            if (~layer3_output_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_1_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_1_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_1_U.if_write} TLF_FIFO}
                        if ((~layer3_output_1_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_1_U.if_write)) begin
                            if (~layer3_output_1_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_1_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_1_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_1_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_2_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_2_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_2_U.if_write} TLF_FIFO}
                        if ((~layer3_output_2_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_2_U.if_write)) begin
                            if (~layer3_output_2_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_2_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_2_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_2_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_3_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_3_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_3_U.if_write} TLF_FIFO}
                        if ((~layer3_output_3_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_3_U.if_write)) begin
                            if (~layer3_output_3_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_3_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_3_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_3_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_4_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_4_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_4_U.if_write} TLF_FIFO}
                        if ((~layer3_output_4_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_4_U.if_write)) begin
                            if (~layer3_output_4_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_4_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_4_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_4_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_5_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_5_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_5_U.if_write} TLF_FIFO}
                        if ((~layer3_output_5_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_5_U.if_write)) begin
                            if (~layer3_output_5_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_5_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_5_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_5_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_6_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_6_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_6_U.if_write} TLF_FIFO}
                        if ((~layer3_output_6_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_6_U.if_write)) begin
                            if (~layer3_output_6_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_6_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_6_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_6_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_7_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_7_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_7_U.if_write} TLF_FIFO}
                        if ((~layer3_output_7_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_7_U.if_write)) begin
                            if (~layer3_output_7_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_7_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_7_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_7_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_8_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_8_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_8_U.if_write} TLF_FIFO}
                        if ((~layer3_output_8_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_8_U.if_write)) begin
                            if (~layer3_output_8_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_8_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_8_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_8_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
// for dep channel 'bnn_bnn.layer3_output_9_U' info is :
// blk sig is {{~bnn_bnn_inst.layer3_output_9_U.if_empty_n & bnn_bnn_inst.Block_entry_gmem_wr_proc_U0.ap_idle & ~bnn_bnn_inst.layer3_output_9_U.if_write} TLF_FIFO}
                        if ((~layer3_output_9_U.if_empty_n & Block_entry_gmem_wr_proc_U0.ap_idle & ~layer3_output_9_U.if_write)) begin
                            if (~layer3_output_9_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'bnn_bnn.layer3_output_9_U' written by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~layer3_output_9_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'bnn_bnn.layer3_output_9_U' read by process 'bnn_bnn.dense_layer_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path bnn_bnn.layer3_output_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (dl_reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge dl_clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg && stop_report_path == 1'b0) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        @(negedge dl_clock);
                        @(negedge dl_clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg)) & ~(|(reported_proc & dl_in_vec))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else if (~(|(dl_in_vec)))begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
