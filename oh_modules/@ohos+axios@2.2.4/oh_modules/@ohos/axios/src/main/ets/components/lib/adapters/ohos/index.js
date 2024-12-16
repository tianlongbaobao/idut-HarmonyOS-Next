/*
 * The MIT License (MIT)
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */

import http from './http.js'
import download from './download.js'
import upload from './upload.js'
import fs from '@ohos.file.fs';
import utils from '../../utils';
import buffer from '@ohos.buffer';
import _http from '@ohos.net.http';
import FormData from '../../env/classes/FormData.js'
import AxiosError from '../../../lib/core/AxiosError'
import buildFullPath from '../../../lib/core/buildFullPath';

const isXHRAdapterSupported = true
const part = '/data/storage/';

export default isXHRAdapterSupported && function (config) {
    return new Promise(function (resolve, reject) {
        const httpConfig = setHttpConfig(config, reject);
        if (config.data && config.data instanceof FormData && (config.method.toUpperCase() === 'POST' || config.method.toUpperCase() === 'PUT')) {
            // 上传
            upload(httpConfig, resolve, reject);
        } else if (config.filePath) {
            // 下载。如果文件已存在，则直接返回错误。
            try {
                let path = '';
                let cacheDir = '';
                let filePath = config.filePath;
                if(config.context) {
                    cacheDir = config.context.cacheDir;
                    path = config.filePath.indexOf(cacheDir) > -1 ?  filePath : `${cacheDir}/${filePath}`;
                } else {
                    if(filePath.indexOf(part)===-1) {
                        return reject(new AxiosError('If there is no context, the filePath must be a complete fd path!', AxiosError.ERR_BAD_OPTION, null, null, null));
                    }
                }
                let res = fs.accessSync(path);
                if(!res){
                    download(httpConfig, resolve, reject);
                }else {
                    reject(new AxiosError('The file already exist, please delete the file first!', AxiosError.ERR_BAD_OPTION, null, null, null));
                }
            } catch (err) {
                reject(new AxiosError(err, AxiosError.ERR_BAD_OPTION, null, null, null));
            }
        } else {
            // 发送请求
            http(httpConfig, resolve, reject);
        }
    })
}
/**
 * @param data 需要计算字节的数据
 */
const calculateLength = (data) => {
    let len = 0;
    if (data) {
        if (typeof data === 'string') {
            // 如果请求体是字符串，直接计算长度
            len = buffer.byteLength(data, 'utf8');
        } else if (buffer.isBuffer(data)) {
            // 如果请求体是Buffer对象，直接获取长度
            len = data.length;
        } else if (data instanceof ArrayBuffer) {
            // 如果请求体是ArrayBuffer对象，直接获取长度
            len = data.byteLength;
        } else if (typeof data === 'number') {
            // 如果请求体是number，直接赋值
            len = data;
        }else {
            // 对象
            let tmp = data;
            if (utils.isFormData(data)) {
                function formDataToObject(formData) {
                    let object = {};
                    formData.forEach(function (value, key) {
                        object[key] = value;
                    });
                    return object;
                }
                tmp = formDataToObject(data);
            }
            // 如果请求体是对象，将其转换为字符串后计算长度
            len = buffer.byteLength(JSON.stringify(tmp), 'utf8');
        }
    }
    return len;
}
/**
 * @param config 请求配置项
 * @param reject 失败回调
 */
const judgeMaxBodyLength = (config, reject) => {
    // 计算请求体大小
    let requestBodyLength = calculateLength(config.data);
    if (config.maxBodyLength > -1 && requestBodyLength > config.maxBodyLength) {
        return reject(new AxiosError('Request body larger than maxBodyLength limit', AxiosError.ERR_BAD_REQUEST, config));
    }
}
/**
 * @param data 响应数据
 * @param config 请求配置项
 * @param reject 失败回调
 * @param lastRequest 请求实例
 * @param handle 校验后回调
 */
const judgeMaxContentLength = (data, config, reject, lastRequest, handle) => {
    // 计算响应大小
    let maxContentLength = calculateLength(data);
    let valid = true;
    if (config.maxContentLength > -1 && maxContentLength > config.maxContentLength) {
        valid = false;
    }
    handle&&handle(valid);
    // 返回内容大于config.maxContentLength抛出异常
    if(!valid) {
        return reject(new AxiosError(
            'maxContentLength size of ' + config.maxContentLength + ' exceeded',
            AxiosError.ERR_BAD_RESPONSE,
            config,
            lastRequest
        ));
    }
}
/**创建请求任务
 * @param config 请求配置项
 * @param reject 失败回调
 */
const setHttpConfig = (config, reject) => {
    // 每一个httpRequest对应一个http请求任务，不可复用
    let httpRequest = _http.createHttp();
    let fullPath = buildFullPath(config.baseURL, config.url);
    // url校验
    if (!fullPath) {
        return reject(new AxiosError("Cannot read properties of url!", AxiosError.ERR_BAD_OPTION, config, null, null));
    } else if (typeof (fullPath) !== 'string') {
        return reject(new AxiosError("Url type should be character type！", AxiosError.ERR_BAD_OPTION_VALUE, config, null, null));
    }
    // 判断设置的请求体的大小
    judgeMaxBodyLength(config, reject);
    return {
        httpRequest,
        fullPath,
        config
    }
}
/**设置请求自定义配置项
 * @param config 请求配置项
 * @param handle 处理options的函数
 */
const setOptions = (config, handle) => {
    let options = {
        method: config.method.toUpperCase(),
        header: config.headers, // 开发者根据自身业务需要添加header字段
        readTimeout: 0,
        maxLimit: -1// 默认放开http request的5MB限制，在axios层的maxBodyLength进行长度限制
    }
    handle && handle(options)
    // 设置请求体
    if (!utils.isUndefined(config.data)) { // 当使用POST请求时此字段用于传递内容
        options.extraData = config.data;
    }
    // 设置连接超时
    if (utils.isNumber(config.connectTimeout)) {
        options.connectTimeout = config.connectTimeout;
    }
    // 设置读取超时
    if (utils.isNumber(config.timeout)) {
        options.readTimeout = config.timeout;
    }
    // 设置读取超时
    if (utils.isNumber(config.readTimeout)) {
        options.readTimeout = config.readTimeout;
    }
    // 设置响应消息的最大字节
    if (utils.isNumber(config.maxContentLength)) {
        options.maxLimit = config.maxContentLength;
    }
    // 设置responseType
    if (!utils.isUndefined(config.responseType)) {
        let responseType = config.responseType.toUpperCase()
        switch (responseType) {
            case 'STRING':
                options.expectDataType = 0
                break;
            case 'OBJECT':
                options.expectDataType = 1
                break;
            case 'ARRAY_BUFFER':
                options.expectDataType = 2
                break;
        }
    }

    // 设置优先级
    if (utils.isNumber(config.priority)) {
        options.priority = config.priority;
    }
    // 设置caPath
    if (config.caPath) {
        options.caPath = config.caPath;
    }
    // 设置客户端证书
    if (!utils.isUndefined(config.clientCert)) {
        options.clientCert = config.clientCert;
        // keyPasswd转换为keyPassword
        let { keyPasswd: keyPassword, ...rest } = options.clientCert;
        let clientCert = { ...rest, keyPassword };
        // certType转换为大小字符
        let certType = clientCert.certType;
        clientCert.certType = certType ? certType.toUpperCase() : certType;
        options.clientCert = clientCert;
    }
    // 设置代理
    if (!utils.isUndefined(config.proxy)) {
        options.usingProxy = config.proxy;
    }
    return options;
}

export { setHttpConfig, setOptions, judgeMaxContentLength }