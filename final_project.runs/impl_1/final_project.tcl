# 
# Report generation script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7a35tcsg324-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.cache/wt [current_project]
  set_property parent.project_path D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.xpr [current_project]
  set_property ip_output_repo D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.runs/synth_1/final_project.dcp
  read_ip -quiet D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.srcs/sources_1/ip/level2_rom/level2_rom.xci
  read_ip -quiet D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.srcs/sources_1/ip/dcm_25m/dcm_25m.xci
  read_ip -quiet D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.srcs/sources_1/ip/level1_rom/level1_rom.xci
  read_xdc D:/106501015/final_project-20190620T020243Z-001/final_project/final_project.srcs/constrs_1/new/const.xdc
  link_design -top final_project -part xc7a35tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force final_project_opt.dcp
  create_report "impl_1_opt_report_drc_0" "report_drc -file final_project_drc_opted.rpt -pb final_project_drc_opted.pb -rpx final_project_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design 
  write_checkpoint -force final_project_placed.dcp
  create_report "impl_1_place_report_io_0" "report_io -file final_project_io_placed.rpt"
  create_report "impl_1_place_report_utilization_0" "report_utilization -file final_project_utilization_placed.rpt -pb final_project_utilization_placed.pb"
  create_report "impl_1_place_report_control_sets_0" "report_control_sets -verbose -file final_project_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force final_project_routed.dcp
  create_report "impl_1_route_report_drc_0" "report_drc -file final_project_drc_routed.rpt -pb final_project_drc_routed.pb -rpx final_project_drc_routed.rpx"
  create_report "impl_1_route_report_methodology_0" "report_methodology -file final_project_methodology_drc_routed.rpt -pb final_project_methodology_drc_routed.pb -rpx final_project_methodology_drc_routed.rpx"
  create_report "impl_1_route_report_power_0" "report_power -file final_project_power_routed.rpt -pb final_project_power_summary_routed.pb -rpx final_project_power_routed.rpx"
  create_report "impl_1_route_report_route_status_0" "report_route_status -file final_project_route_status.rpt -pb final_project_route_status.pb"
  create_report "impl_1_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file final_project_timing_summary_routed.rpt -pb final_project_timing_summary_routed.pb -rpx final_project_timing_summary_routed.rpx -warn_on_violation "
  create_report "impl_1_route_report_incremental_reuse_0" "report_incremental_reuse -file final_project_incremental_reuse_routed.rpt"
  create_report "impl_1_route_report_clock_utilization_0" "report_clock_utilization -file final_project_clock_utilization_routed.rpt"
  create_report "impl_1_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file final_project_bus_skew_routed.rpt -pb final_project_bus_skew_routed.pb -rpx final_project_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force final_project_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force final_project.mmi }
  write_bitstream -force final_project.bit 
  catch {write_debug_probes -quiet -force final_project}
  catch {file copy -force final_project.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

