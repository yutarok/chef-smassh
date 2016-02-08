#
# Cookbook Name:: misc
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# setenforce 0で一時的にSELinuxを無効化し、
# /etc/selinux/configの作成を通知する
# selinuxenabledコマンドの終了ステータスが0(selinuxが有効)の場合だけ実行される
execute "disable selinux enforcement" do
  only_if "which selinuxenabled && selinuxenabled"
  command "setenforce 0"
  action :run
  notifies :create, "template[/etc/selinux/config]"
end

# 再起動の際もSELinuxの無効状態を維持するために、
# /etc/selinux/configに、設定を記述する
template "/etc/selinux/config" do
  source "sysconfig/selinux.erb"
  variables(
    :selinux => "disabled",
    :selinuxtype => "targeted"
  )
  action :nothing
end

# application
%w{
vim-enhanced
git
epel-release
}.each do |pkg|
  package do pkg
    action :install
  end
end

# service
%w{
ntp
}.each do |pkg|
  package do pkg
    action :install
  end
end


# ntpdate ntp.nict.jp

