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
'use strict';

import buildURL from '../../../lib/helpers/buildURL.js';
import settle from "../../../lib/core/settle";
import AxiosError from '../../../lib/core/AxiosError';
import request from '@ohos.request';
import fs from '@ohos.file.fs';
import { setOptions, judgeMaxContentLength } from './index';
import { LogUtil } from '../../LogUtil'

function download(httpConfig, resolve, reject) {
    const { httpRequest,fullPath,config } = httpConfig;
    let options = setOptions(config, options => {
        // 添加filePath
        if (config.filePath) {
            options.filePath = config.filePath;
        }
    });
    let response = {
        data: null,
        status: 0,
        statusText: "",
        headers: config.header,
        config: config,
        request: httpRequest
    };

    function settleResult(data, code) {
        response.data = data;
        response.status = code;
        settle(function _resolve(value) {
            resolve(value);
        }, function _reject(err) {
            reject(err);
        }, response);
    }

    // 发送下载请求
    try {
        const fileStream = fs.createStreamSync(options.filePath, "a+");
        httpRequest.on("headersReceive", (header) => {
            response.headers = header;
            const totalSize = Number(header['content-length']);
            if(totalSize) {
                judgeMaxContentLength(totalSize, config, reject, httpRequest,(valid)=>{
                    // 校验失败，移除监听
                    if(!valid) {
                        removeEvent(httpRequest);
                        fileStream.close();
                    }
                });
            }
        });
        // 用于订阅HTTP流式响应数据接收进度事件
        httpRequest.on('dataReceiveProgress', ({receiveSize,totalSize}) => {
            if (typeof config.onDownloadProgress === 'function') {
                config.onDownloadProgress({
                    loaded: receiveSize,
                    total: totalSize
                })
            }
        });
        httpRequest.on('dataReceive', (arraybuffer) => {
            try {
                if (fileStream.writeSync(arraybuffer)) {
                    // 如果写入成功，则不需要定时器
                    return;
                }
                // 如果写入失败，则加入定时器，控制写入速度
                const timer = setTimeout(() => {
                    if (fileStream.writeSync(arraybuffer)) {
                        // 写入成功，则清空定时器
                        clearTimeout(timer);
                    }
                }, 1000);
            } catch (err) {
                removeEvent(httpRequest);
                let s = JSON.stringify(err);
                reject(new AxiosError(s, AxiosError.ERR_BAD_RESPONSE, config, request, request));
            }
        });
        // 用于订阅HTTP流式响应数据接收完毕事件
        httpRequest.on('dataEnd', () => {
            removeEvent(httpRequest);
            fileStream.close()

        });
        // 填写http请求的url地址，可以带参数也可以不带参数。URL地址需要开发者自定义。GET请求的参数可以在extraData中指定
        let url = buildURL(fullPath, config.params, config.paramsSerializer)
        LogUtil.debug(`download url:${url}, options: ${JSON.stringify(options)}`);
        httpRequest.requestInStream(url, options,
            (err, data) => {
                response.status = data;
                if (!err) {
                    let resultData = '';
                    if (data === 200 || data === 304) {
                        resultData = 'download success!';
                    }
                    settleResult(resultData, data);
                } else {
                    removeEvent(httpRequest);
                    reject(new AxiosError(JSON.stringify(err), null, config, request, request));
                }
            }
        )
    } catch (err) {
        removeEvent(httpRequest);
        let s = JSON.stringify(err);
        reject(new AxiosError(s, AxiosError.ERR_BAD_OPTION_VALUE, config, request, request));
    }
}
// 移除监听
const removeEvent = (httpRequest) => {
    httpRequest.off('headersReceive');
    // 取消订阅HTTP流式响应数据接收事件
    httpRequest.off('dataReceive');
    // 取消订阅HTTP流式响应数据接收进度事件
    httpRequest.off('dataReceiveProgress');
    httpRequest.off('dataEnd');
    // 当该请求使用完毕时，调用destroy方法主动销毁
    httpRequest.destroy();
}

export default download
