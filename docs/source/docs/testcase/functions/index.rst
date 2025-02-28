功能测试
===============

    测试环境搭建，参考 :ref:`典型安装拓扑`

升级测试
----------
        #. `2000-采集器_主控(MA)升级 </_static/testcase/单元测试/采集器-BT升级测试.xlsx>`_
        #. `2001-采集器_蓝牙(MA)升级 </_static/testcase/单元测试/采集器-MA升级测试.xlsx>`_
        #. `2002-控制器_升级 </_static/testcase/单元测试/控制器-升级测试.xlsx>`_
        #. `2003-人体(MA)升级 </_static/testcase/单元测试/采集器-MA升级测试.xlsx>`_

HTTP交互
---------
.. toctree::
        :maxdepth: 1

        id-2010.rst


控制测试
---------
.. toctree::
        :maxdepth: 1

        id-2100.rst
        id-2101.rst
        id-2102.rst
        id-2103.rst

----

ApiFox分合闸用例设置
---------------------
        .. image:: /_static/imags/apifox-testcase-switch.png
                :width: 80%

ApiFox分合闸用例执行过程
------------------------
        .. image:: /_static/imags/apifox-testcase-switch_01.png
                :width: 80%

        如上图所示，测试用例执行过程是将选定的 http api 逐个执行。图中 api 共两条，当两条api全部执行完毕后，会再次开始循环执行 选中的两条 api，直到达到预设的10轮为止。
        执行命令前会有20秒延时，延时过后立即执行。
        图中显示的“通过”，仅代表控制指令发送到了控制器，不能代表采集器已经执行了命令。
        