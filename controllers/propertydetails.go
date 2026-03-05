package controllers

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	beego "github.com/beego/beego/v2/server/web"
)

type PropertyDetailsController struct {
	beego.Controller
}

func (c *PropertyDetailsController) Get() {
	ids := c.GetString("ids")

	apiURL := "https://presto:TRAV3LA1@ownerdirect.beta.123presto.com/api/property/bookmark/v1?propertyIdList=" + ids

	fmt.Println("PropertyDetails URL:", apiURL[:min(len(apiURL), 200)])

	req, _ := http.NewRequest("GET", apiURL, nil)
	req.Header.Set("X-Requested-With", "XMLHttpRequest")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Request error:", err)
		c.Data["json"] = map[string]string{"error": err.Error()}
		c.ServeJSON()
		return
	}
	defer resp.Body.Close()

	// Read body
	bodyBytes, err2 := io.ReadAll(resp.Body)
	if err2 != nil {
		fmt.Println("Read error:", err2)
	} else {
		fmt.Println("Response status:", resp.StatusCode)
		fmt.Println("Response body:", string(bodyBytes[:min(len(bodyBytes), 500)]))
	}

	var result map[string]interface{}
	json.Unmarshal(bodyBytes, &result)

	c.Data["json"] = result
	c.ServeJSON()
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
