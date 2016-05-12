
# apache 

    LoadModule php5_module "D:/server/php/php5apache2_2.dll"
    AddType application/x-httpd-php .php .php5 .php4 .php3 .phtml .phpt
    AddType application/x-httpd-php-source .phps
    # configure the path to php.ini
    PHPIniDir "D:/server/php"



    <Directory "D:/server/apache/htdocs">
        #
        # Possible values for the Options directive are "None", "All",
        # or any combination of:
        #   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
        #
        # Note that "MultiViews" must be named *explicitly* --- "Options All"
        # doesn't give it to you.
        #
        # The Options directive is both complicated and important.  Please see
        # http://httpd.apache.org/docs/2.2/mod/core.html#options
        # for more information.
        #
        Options Indexes FollowSymLinks

        #
        # AllowOverride controls what directives may be placed in .htaccess files.
        # It can be "All", "None", or any combination of the keywords:
        #   Options FileInfo AuthConfig Limit
        #
        AllowOverride None

        #
        # Controls who can get stuff from this server.
        #
        Order allow,deny
        Allow from all

    </Directory>

# http vhost

    <VirtualHost *:80>
        ServerAdmin peng_du2007@qq.com
        DocumentRoot "D:/www/mysql.local"
        ServerName mysql.local
        <Directory "D:/www/mysql.local">
            Options Indexes FollowSymLinks
            AllowOverride ALL
            Order deny,allow
            Allow from all
        </Directory>
        ErrorLog "logs/error.log"
        CustomLog "logs/access.log" common
    </VirtualHost>