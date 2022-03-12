#!/bin/bash

function make_cache() {
  image_path=$1
  tmp_dir="/home/wankun/.singularity/run/cache/$(basename $image_path)"
  mkdir -p $tmp_dir $tmp_dir/home > /dev/null 2>&1
  echo $tmp_dir
}

function run_ros_container() {
  image_path=$1
  tmp_dir=$(make_cache $image_path)
  if [[ $USER == "root" ]]; then
    singularity run \
      --writable \
      --home $tmp_dir/home:$HOME \
      --bind $PWD:$HOME/workspace \
      $image_path
  else
    singularity run \
      --nv \
      --home $tmp_dir/home:$HOME \
      --bind $PWD:$HOME/workspace \
      $image_path
  fi
}

function exec_ros_container() {
  image_path=$1
  tmp_dir=$(make_cache $image_path)
  ros_distro=$(basename $image_path)
  cmd_exec=${@:2}
  cmd_source_ros="source /opt/ros/$ros_distro/setup.bash"
  cmd_full="${cmd_source_ros} && $cmd_exec"
  echo "Executing \"$cmd_exec\" in $ros_distro container..."
  if [[ $USER == "root" ]]; then
    singularity exec \
      --writable \
      --home $tmp_dir/home:$HOME \
      --bind $PWD:$HOME/workspace \
      $image_path \
      /bin/bash -c "$cmd_full"
  else
    singularity exec \
      --nv \
      --home $tmp_dir/home:$HOME \
      --bind $PWD:$HOME/workspace \
      $image_path \
      /bin/bash -c "$cmd_full"
  fi
}
