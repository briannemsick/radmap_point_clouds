radmap.lua

-- 4 scans, 2 from each lidar, is a "full scan"
TRAJECTORY_BUILDER_3D.scans_per_accumulation = 4

MAP_BUILDER.use_trajectory_builder_3d = true 
MAP_BUILDER.num_background_threads = 7 

MAP_BUILDER.sparse_pose_graph.optimization_problem.huber_scale = 5e2 
MAP_BUILDER.sparse_pose_graph.optimize_every_n_scans = 80 -- pose graph every 80 full scans
MAP_BUILDER.sparse_pose_graph.constraint_builder.sampling_ratio = 0.1 -- downsample to 10%
MAP_BUILDER.sparse_pose_graph.optimization_problem.ceres_solver_options.max_num_iterations = 10
MAP_BUILDER.sparse_pose_graph.optimization_problem.rotation_weight = 3e4 -- 10x higher than default because of good IMU
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.rotation_weight = 2e4 -- 10x higher than default because of good IMU

-- Reuse the coarser 3D voxel filter to speed up the computation of loop closure
-- constraints.
MAP_BUILDER.sparse_pose_graph.constraint_builder.adaptive_voxel_filter = TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter
MAP_BUILDER.sparse_pose_graph.constraint_builder.min_score = 0.3 -- low barrier to match loop closure
MAP_BUILDER.sparse_pose_graph.constraint_builder.global_localization_min_score = 0.3 -- low barrier to match loop closure
MAP_BUILDER.sparse_pose_graph.constraint_builder.max_constraint_distance = 100 -- increase to 250 for wide area with GPS

assets_writer_radmap.lua

VOXEL_SIZE = 5e-2 -- voxel filter size
pipeline = {
    {
      action = "fixed_ratio_sampler",
      sampling_ratio = 0.3, -- downsample to 30%
    },
    {
      action = "min_max_range_filter",
      min_range = 8.25, -- min lidar range (removes truck)
      max_range = 150., -- max lidar range
    }
    

