#!/bin/bash
APPDIR=/home/job/.config/Mutate/scripts/docker
function get_images {
	if [ "$2" != "" ] ; then
		list=$(docker images | awk 'NR>1{print $0}' | grep "$2")
	else
		list=$(docker images | awk 'NR>1{print $0}')
	fi
	if [ "$list" == "" ] ; then
		echo "[未找到镜像]"
		echo "command="
		echo "icon=$APPDIR/404.png"
		echo "subtext=未找到Docker镜像：$2"
		exit 0
	fi
	echo "$list" | sed 's/[ ]\{2,\}/\t/g' | sed 's/ /\*/g' | while read reponame repotag imageid created imagesize
	do
		if [ "$repotag" != "TAG" ] ; then
			created=$(echo $created | sed 's/\*/ /g')
			imagesize=$(echo $imagesize | sed 's/\*/ /g')
			echo "[$reponame:$repotag]"
			echo "command=gnome-terminal -e \"$APPDIR/run.sh $reponame $repotag\" &"
			echo "icon=$APPDIR/docker.png"
			echo "subtext=镜像ID:$imageid 大小:$imagesize 时间:$created"
		fi
	done
}
function get_ps {
	if [ "$2" != "" ] ; then
		list=$(docker ps -a | grep "$2")
	else
		list=$(docker ps | awk 'NR>1{print $0}')
	fi
	if [ "$list" == "" ] ; then
		echo "[未找到容器]"
		echo "command="
		echo "icon=$APPDIR/404.png"
		echo "subtext=未找到Docker容器：$2"
		exit 0
	fi
	echo "$list" | sed 's/[ ]\{2,\}/\t/g' | sed 's/ /\*/g' | while read containerid image command created status ports names
	do
		if [ "$image" != "IMAGE" ] ; then
			if [ "$names" == "" ] ; then
				names=$ports
				ports=""
			fi
			created=$(echo $created | sed 's/\*/ /g')
			status=$(echo $status | sed 's/\*/ /g')
			isexit=$(echo $status | grep 'Exited')
			echo "[$names ( 镜像:$image )]"
			if [ "$isexit" == "" ] ; then
				echo "command="
				echo "icon=$APPDIR/image.png"
			else
				echo "command="
				echo "icon=$APPDIR/exited.png"
			fi
			echo "subtext=容器ID:$containerid 状态:$status 时间:$created"
		fi
	done
}
function get_kill {
	if [ "$2" != "" ] ; then
		list=$(docker ps | grep "$2")
	else
		list=$(docker ps | awk 'NR>1{print $0}')
	fi
	if [ "$list" == "" ] ; then
                echo "[未找到容器]"
                echo "command="
                echo "icon=$APPDIR/404.png"
                echo "subtext=未找到运行的容器：$2"
                exit 0
        fi
	echo "[结束运行的容器]"
	echo "command=$APPDIR/killall.sh"
	echo "icon=$APPDIR/docker.png"
	echo "subtext=结束清单中的Docker容器"
        echo "$list" | sed 's/[ ]\{2,\}/\t/g' | sed 's/ /\*/g' | while read containerid image command created status ports names
        do
                if [ "$image" != "IMAGE" ] ; then
                        if [ "$names" == "" ] ; then
                                names=$ports
                                ports=""
                        fi
                        created=$(echo $created | sed 's/\*/ /g')
                        status=$(echo $status | sed 's/\*/ /g')
                        echo "[$names ( 镜像:$image )]"
                        echo "command=docker kill $containerid"
                        echo "icon=$APPDIR/image.png"
                        echo "subtext=容器ID:$containerid 状态:$status 时间:$created"
                fi
        done
}
function get_rm {
	if [ "$2" != "" ] ; then
		list=$(docker ps -a | grep 'Exited' | grep "$2")
	else
		list=$(docker ps -a | grep 'Exited')
	fi
	if [ "$list" == "" ] ; then
                echo "[未找到容器]"
                echo "command="
                echo "icon=$APPDIR/404.png"
                echo "subtext=未找到容器：$2"
                exit 0
        fi
        echo "[删除容器]"
        echo "command=$APPDIR/rmall.sh $2"
        echo "icon=$APPDIR/docker.png"
        echo "subtext=删除清单中的Docker容器"
        echo "$list" | sed 's/[ ]\{2,\}/\t/g' | sed 's/ /\*/g' | while read containerid image command created status ports names
        do
                if [ "$image" != "IMAGE" ] ; then
                        if [ "$names" == "" ] ; then
                                names=$ports
                                ports=""
                        fi
                        created=$(echo $created | sed 's/\*/ /g')
                        status=$(echo $status | sed 's/\*/ /g')
                        echo "[$names ( 镜像:$image )]"
                        echo "command=docker rm $containerid"
                        echo "icon=$APPDIR/image.png"
                        echo "subtext=容器ID:$containerid 状态:$status 时间:$created"
                fi
        done
}
function proc_cmd {
	case $1 in
	images)
		get_images $*
		;;
	i)
		get_images $*
		;;
	ps)
		get_ps $*
		;;
	p)
		get_ps $*
		;;
	kill)
		get_kill $*
		;;
	k)
		get_kill $*
		;;
	rm)
		get_rm $*
		;;
	r)
		get_rm $*
		;;
	*)
		echo "[命令: $1]"
		echo "command=copy"
		echo "icon=$APPDIR/404.png"
		echo "subtext=支持的命令：images，ps，kill，rm"
		;;
	esac
}
proc_cmd $1
