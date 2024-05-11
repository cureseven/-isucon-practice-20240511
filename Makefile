.PHONY: init start stop create tuncate-logs gogo
init: webapp/sql/dump.sql.bz2 benchmarker/userdata/img

webapp/sql/dump.sql.bz2:
	cd webapp/sql && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/dump.sql.bz2

benchmarker/userdata/img.zip:
	cd benchmarker/userdata && \
	curl -L -O https://github.com/catatsuy/private-isu/releases/download/img/img.zip

benchmarker/userdata/img: benchmarker/userdata/img.zip
	cd benchmarker/userdata && \
	unzip -qq -o img.zip

create:
	cd webapp/golang && make all

stop:
	sudo systemctl stop nginx
	sudo systemctl stop isu-go
	sudo systemctl stop mysql

start:
	sudo systemctl start mysql
	sleep 5
	sudo systemctl start isu-go
	sudo systemctl start nginx

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.log
	sudo chmod 777 /var/log/mysql/mysql-slow.log
	sudo journalctl --vacuum-size=1K

gogo: stop create truncate-logs start
