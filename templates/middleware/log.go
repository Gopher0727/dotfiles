package middleware

import (
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

/*

func main() {
	// 初始化 zap 日志库
	logger, err := middleware.NewZapLogger()
	if err != nil {
		panic("init zap logger failed")
	}
	defer logger.Sync()

	r := gin.Default()
	r.Use(middleware.ZapAccessLogger(logger))

	// ...
}

*/

type HourlyFileWriter struct {
	mu      sync.Mutex
	dir     string
	prefix  string
	curHour string
	file    *os.File
}

func NewHourlyFileWriter(dir, prefix string) (*HourlyFileWriter, error) {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return nil, err
	}
	return &HourlyFileWriter{
		dir:    dir,
		prefix: prefix,
	}, nil
}

func (w *HourlyFileWriter) Write(p []byte) (int, error) {
	w.mu.Lock()
	defer w.mu.Unlock()

	hour := time.Now().Format("2006-01-02-15")
	if hour != w.curHour || w.file == nil {
		if w.file != nil {
			_ = w.file.Close()
		}

		name := filepath.Join(w.dir, w.prefix+"-"+hour+"h.log")
		f, err := os.OpenFile(name, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0o644)
		if err != nil {
			return 0, err
		}
		w.file = f
		w.curHour = hour
	}
	return w.file.Write(p)
}

func (w *HourlyFileWriter) Sync() error {
	w.mu.Lock()
	defer w.mu.Unlock()

	if w.file != nil {
		return w.file.Sync()
	}
	return nil
}

func NewZapLogger() (*zap.Logger, error) {
	fileCfg := zapcore.EncoderConfig{
		MessageKey:     "",
		LevelKey:       "level",
		TimeKey:        "time",
		StacktraceKey:  "stack",
		EncodeLevel:    zapcore.CapitalLevelEncoder,
		EncodeTime:     zapcore.TimeEncoderOfLayout("2006-01-02 15:04:05"),
		EncodeDuration: zapcore.StringDurationEncoder,
		EncodeCaller:   zapcore.ShortCallerEncoder,
	}

	w, err := NewHourlyFileWriter("logs", "access")
	if err != nil {
		return nil, err
	}

	fileCore := zapcore.NewCore(
		zapcore.NewJSONEncoder(fileCfg),
		zapcore.AddSync(w),
		zap.InfoLevel,
	)

	return zap.New(fileCore), nil
}

func ZapAccessLogger(base *zap.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		requestID := c.GetHeader("X-Request-Id")
		if len(requestID) == 0 {
			requestID = uuid.NewString()
		}
		c.Writer.Header().Set("X-Request-Id", requestID)

		start := time.Now()
		c.Next()
		cost := time.Since(start)

		fields := []zap.Field{
			zap.String("request_id", requestID),
			zap.String("method", c.Request.Method),
			zap.String("path", c.Request.URL.Path),
			zap.String("query", c.Request.URL.RawQuery),
			zap.Int("status", c.Writer.Status()),
			zap.Duration("latency", cost),
			zap.String("client_ip", c.ClientIP()),
			zap.String("user_agent", c.Request.UserAgent()),
		}

		switch {
		case c.Writer.Status() >= 500:
			base.Error("http_request", fields...)
		case c.Writer.Status() >= 400:
			base.Warn("http_request", fields...)
		default:
			base.Info("http_request", fields...)
		}
	}
}
