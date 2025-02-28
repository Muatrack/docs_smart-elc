工厂测试 AT
============

    铁塔控制器的出厂测试功能, 通过板载串口与上位机连接, 开启AT服务并响应上位机的AT指令。

数据存储
----------

    AT命令中涉及部分数据需要控制器存储，在此列名存储的方式。

    - SN、设备证书、出厂信息 ：存储在独立的分区中，分区无文件系统，直接裸存。因此当SN或证书其一写入时发现FLASH分区未格式化，将会执行格式化，进而导致 sn 或者证书 已写入的内容（如有）被擦除。
    - FLASH中SN占用16字节，出厂信息占用64字节，设备证书占用512字节

静默开启/关闭
-------------------

    当静默开启后, 总线上的设备将依据后续AT命令中携带的SN判断是否响应AT指令。

    .. code::

        >> AT+SILENCE=CLOSE/OPEN,FFFFFFFFFFFFFFFF
    
    - CLOSE/OPEN: 设置静默关闭与开启
    - FFFFFFFFFFFFFFFF: 总线上设备的SN, 当期望所有总线设备接收并响应此AT命令时, SN的值应为 FFFFFFFFFFFFFFFF

    响应数据:
    
    .. code::

        >> AT+SILENCE=CLOSE,FFFFFFFFFFFFFFFF
        << OK       //成功

启动板级测试
-------------------

    此命令执行前总线上的设备对后续AT指令不做回应。

    .. code::

        >> AT+STARTCHECK=PCBA,FFFFFFFFFFFFFFFF

    - PCBA: 固定字串
    - SN: 当期望所有总线设备接收并响应此AT命令时, SN的值应为 FFFFFFFFFFFFFFFF

    响应数据:
    
    .. code::

        >> AT+STARTCHECK=PCBA,FFFFFFFFFFFFFFFF
        << OK       //成功

搜索总线设备
-----------------------

    .. code::

        >> AT+SEARCH=FFFFFFFFFFFFFFFF

    响应数据:
    
    .. code::

        >> AT+SEARCH=FFFFFFFFFFFFFFFF
        << {"OT":"","SN":"E202321D2123800C"}    //成功,当前版本
        << E202321D2123800C                     //成功,下一版本

    - OT: 暂未启用,保持结构
    - SN: 收到指令且成功响应的设备SN

写入SN到控制器
--------------------

    .. code::

        >> AT+SN=E0000000000000EA

    响应数据:
    
    .. code::

        >> AT+SN=E0000000000000EA
        << OK       //成功
        << +ERROR:-1    //失败

读取SN
-------

    .. code::

        >> AT+SN?
        
    响应数据:
    
    .. code::

        >> AT+SN?
        << E0000000000000EA
           OK                       //成功
        << +ERROR:-1                //失败. 典型场景, 设备未设置过SN时

写证书到控制器
---------------------

    .. code::

        >> AT+AUTHWRITE=SIZE,B64(xbkdiazdkwofklald..)

    - SIZE: 表示后面将要写入证书字串的字节长度
    - B64(...): 经过base64编码的证书数据

    响应数据:
    
        .. code::

            >> AT+AUTHWRITE=24,a2traWlramFsa2pzYWRmYQ==
            << OK           //成功
            << +ERROR:-1    //失败
        
读控制器证书
------------------

    .. code::

        >> AT+AUTHWRITE?

    响应数据:

        .. CODE::

            >> AT+AUTHWRITE?
            << a2dba05ba6fca29320b62a0000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000000000000000000000
                OK                           //成功
            <<  +ERROR:-1                       //失败

总线设备PING(略)
------------------

    .. CODE::

        >> AT+PING=FFFFFFFFFFFFFFFF

    响应数据:

        .. code::
            
            >> AT+PING=FFFFFFFFFFFFFFFF
            << OK
            << +ERROR:-1                    //失败

一次读取控制器数据
-------------------

    .. code::
        
        >> AT+READALL?=FFFFFFFFFFFFFFFF

    响应数据:
    
        .. code::
        
            >> AT+READALL?=FFFFFFFFFFFFFFFF
            << {
                    "Data":	{
                        "ExtFmt":	"Formated",                                         // 外部flash是否已经格式化
                        "ExtFlashSize":	16777216,                                       // 控制器外部flash的剩余大小(字节)
                        "InnerFsSize":	2867200,                                        // 控制器内部flash的剩余大小(字节)
                        "MemInter":	109,                                                // 控制器内部mem剩余大小
                        "MemExter":	4694,                                               // 控制器扩展mem剩余大小
                        "AuthCode":	"a2dba05ba6fca29320b62a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",     // 经base64编码的设备证书
                        "FactoryInfo":	{                                               // 出厂信息
                            "DATE":	"2020-01-01 00:00:00",                              // 出厂日历时间
                            "BRAND":	10,                                             // 品牌编号
                            "MANUFACTURE":	20,                                         // 厂商编号
                            "DISTRIBUTOR":	30                                          // 销售商编号
                        },                                             
                        "LteFw":	"AirM2M_780EX_V1164_LTE_AT",                        // LTE module fw
                        "LteCCID":	"89861122227035524405",                             // LTE sim卡的 CCID
                        "LteRssi":	12,                                                 // LTE 信号强度
                        "Rtc":	"2025-02-06 15:16:41",                                  // 控制器的 RTC 时间
                        "FwVer":	"SECO_KSW_001_CO_01_35_280001",                     // 控制器固件版本号
                        "AP":	",0",                                                   // 检索到的周边 WIFI-AP
                        "TempSn":	"",                                                 // 温度传感器SN
                        "TempVal":	0                                                   // 温度传感器温度值
                    },
                    "SN":	"E202321D2123800C",                                         // 设备的SN
                    "UID":	"37 8B 17 92 C5 C7 BA 31 41 20 DD E6 EF 92 D8 3E ",         // 设备唯一码
                    "OT":	"",                                                         // 暂未使用,保持格式
                    "Status":	"",                                                     // 暂未使用,保持格式
                    "Result":	"",                                                     // 暂未使用,保持格式
                    "Message":	""                                                      // 暂未使用,保持格式
                }
                OK                          //成功
            << +ERROR:-1                    //失败

扩展FLASH格式化
---------------------

    .. code::

        >> AT+EXTFMT=FFFFFFFFFFFFFFFF

    响应数据:
        .. code::

            >> AT+EXTFMT=FFFFFFFFFFFFFFFF
            << OK

第二串口验证
--------------------

    .. code::

        >> AT+EXTRS485PING=FFFFFFFFFFFFFFFF
    
    响应数据：

        .. code::

            >> AT+EXTRS485PING=FFFFFFFFFFFFFFFF
            << OK               //成功

RTC写入
--------

    .. CODE::

        >> AT+RTC=1726660800,FFFFFFFFFFFFFFFF

    响应数据:

        .. CODE::

            >> AT+RTC=1726660800,FFFFFFFFFFFFFFFF
            << OK           //成功
            << +ERROR:-1        //失败

读取设备UID
-----------------

    .. code::

        >> AT+RDUID

    响应数据:

        .. code::

            >> AT+RDUID
            << 37 8B 17 92 C5 C7 BA 31 41 20 DD E6 EF 92 D8 3E
               OK

读取老化测试记录
---------------------

    .. CODE::

        >> AT+FACTEST?

    响应数据:

            .. code::
                
                >> AT+FACTEST?
                <<  
                    TST,2024-09-27 14:35:02,318    //测试记录日期，CPU温度值
                    FMT,2024-09-27 14:50:19,0      //flash格式化日期, 0
                    TST,2024-09-27 14:35:02,318    //测试记录日期，CPU温度值
                    ...
                    OK                             //成功
                << +ERROR: -1                      //失败

清除老化记录
------------------

    .. code::

        >> AT+FTSTCLEAN

    响应数据:

        .. code::

            >> AT+FTSTCLEAN
            << OK

写入出厂信息
-------------------

    .. code::

        >> AT+FACINFO=2020-01-01 00:00:00,10,20,30

        - 2020-01-01 00:00:00       //出厂日历时间
        - 10                        //品牌标识
        - 20                        //厂商标识
        - 30                        //销售商标识

    响应数据:

        .. CODE::

            >> AT+FACINFO=2020-01-01 00:00:00,10,20,30
            << OK

查询出厂信息
------------------

    .. code::

        >> AT+FACINFO?

    响应数据:

        .. code::

            >> AT+FACINFO?
            << {"DATE":"2020-01-01 00:00:00","BRAND":10,"MANUFACTURE":20,"DISTRIBUTOR":30}
               OK                   // 成功
            << +ERROR: -1           // 失败

串口输出调试日志开关
------------------------

    .. code::

        >> AT+LOG=on/off
    
    - on:  开启日志输出
    - off: 关闭日志输出

    响应数据:

        .. code::

            >> AT+LOG=on
            << OK

