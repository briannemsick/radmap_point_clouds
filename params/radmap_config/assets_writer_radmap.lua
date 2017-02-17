-- WARNING: we create a lot of X-Rays of a potentially large space in this
-- pipeline. For example, running over the
-- cartographer_paper_deutsches_museum.bag requires ~25GiB of memory. You can
-- reduce this by writing fewer X-Rays or upping VOXEL_SIZE - which is the size
-- of a pixel in a X-Ray.
VOXEL_SIZE = 5e-2

XY_TRANSFORM =  {
  translation = { 0., 0., 0. },
  rotation = { 0., -math.pi / 2., 0., },
}

XZ_TRANSFORM =  {
  translation = { 0., 0., 0. },
  rotation = { 0. , 0., -math.pi / 2, },
}

YZ_TRANSFORM =  {
  translation = { 0., 0., 0. },
  rotation = { 0. , 0., math.pi, },
}

options = {
  tracking_frame = "base_link",
  pipeline = {
    {
      action = "fixed_ratio_sampler",
      sampling_ratio = 0.3,
    },
    {
      action = "min_max_range_filter",
      min_range = 8.25,
      max_range = 150.,
    },
    {
       action = "voxel_filter_and_remove_moving_objects",
       voxel_size = VOXEL_SIZE,
    },
    {
       action = "dump_num_points",
    },

    {
      action = "write_ply",
      filename = "points.ply",
    },

    -- Gray X-Rays. These only use geometry to color pixels.
    {
      action = "write_xray_image",
      voxel_size = VOXEL_SIZE,
      filename = "xray_yz_all",
      transform = YZ_TRANSFORM,
    },
    {
      action = "write_xray_image",
      voxel_size = VOXEL_SIZE,
      filename = "xray_xy_all",
      transform = XY_TRANSFORM,
    },
    {
      action = "write_xray_image",
      voxel_size = VOXEL_SIZE,
      filename = "xray_xz_all",
      transform = XZ_TRANSFORM,
    },
  }
}

return options
