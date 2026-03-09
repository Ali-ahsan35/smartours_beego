package controllers

import (
    "encoding/json"
    "fmt"
    "io"
    "net/http"
    "strings"

    beego "github.com/beego/beego/v2/server/web"
)

type AllController struct {
    beego.Controller
}

func (c *AllController) Get() {
    country := strings.ToLower(c.Ctx.Input.Param(":country"))

    apiURL := "http://localhost:8080/api/v1/category/details/" + country

    fmt.Println("Calling our API:", apiURL)

    req, err := http.NewRequest("GET", apiURL, nil)
    if err != nil {
        c.Data["Error"] = err.Error()
        c.Data["Country"] = country
        c.TplName = "all.tpl"
        return
    }

	// req.Header.Set("X-Requested-With", "XMLHttpRequest")

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        fmt.Println("Error calling our API:", err)
        c.Data["Error"] = err.Error()
        c.Data["Country"] = country
        c.TplName = "all.tpl"
        return
    }
    defer resp.Body.Close()

    bodyBytes, _ := io.ReadAll(resp.Body)
    fmt.Println("Our API status:", resp.StatusCode)

    var result map[string]interface{}
    json.Unmarshal(bodyBytes, &result)

    // After unmarshaling result, extract the data
	geoInfo, _ := result["GeoInfo"].(map[string]interface{})
	propertyCount := ""
	locationName := ""
	breadcrumbs := []interface{}{}

	if geoInfo != nil {
		if count, ok := geoInfo["PropertyCount"].(float64); ok {
			propertyCount = fmt.Sprintf("%.0f+", count)
		}
		if name, ok := geoInfo["ShortName"].(string); ok {
			locationName = name
		}
		if bc, ok := geoInfo["Breadcrumbs"].([]interface{}); ok {
			breadcrumbs = bc
		}
	}

	// After existing geoInfo extraction, add:
	items := []interface{}{}
	if result, ok := result["Result"].(map[string]interface{}); ok {
		if itemsList, ok := result["Items"].([]interface{}); ok {
			items = itemsList
		}
	}

	// Process items to extract first 3 amenities
	processedItems := []map[string]interface{}{}
	for _, item := range items {
		itemMap, ok := item.(map[string]interface{})
		if !ok {
			continue
		}
		prop, _ := itemMap["Property"].(map[string]interface{})
		if prop != nil {
			amenitiesMap, _ := prop["Amenities"].(map[string]interface{})
			top3 := []string{}
			for _, v := range amenitiesMap {
				if len(top3) >= 3 {
					break
				}
				top3 = append(top3, v.(string))
			}
			prop["TopAmenities"] = top3
			itemMap["Property"] = prop
		}
		processedItems = append(processedItems, itemMap)
	}

	c.Data["Items"] = processedItems
	c.Data["Country"] = country
	c.Data["LocationName"] = locationName
	c.Data["PropertyCount"] = propertyCount
	c.Data["Breadcrumbs"] = breadcrumbs
	c.Data["Items"] = items
	c.TplName = "all.tpl"
	// c.Layout = ""  

	// // Load both templates
	// beego.ExecuteTemplate(c.Ctx.ResponseWriter, "all.tpl", c.Data)

}